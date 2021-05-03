import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class AssetsUseCase {
  DatabaseRepositoryAgreement _database;
  AppData _appData;

  AssetsUseCase(DatabaseRepositoryAgreement database, AppData appData) {
    _database = database;
    _appData = appData;
  }

  Future<Either<Notification, List<Asset>>> getAssets(String walletId) async {
    if (!_appData.hasWallet(walletId))
      return Left(Notification('AssetsUseCase.getAssets', 'A carteira informada não foi localizada'));
    final Wallet wallet = _appData.getWalletById(walletId);
    if (wallet.assets.isNotEmpty) return Right(wallet.assets);

    final toInclude = <Type>[Company, Category];
    final response = await _database.filterByRelation(Asset, [Wallet], [walletId], objectsToInclude: toInclude);
    return response.fold((notification) => Left(notification), (list) {
      List<Asset> assets = List<Asset>.from(list);
      assets.forEach((asset) => wallet.addAsset(asset));
      return Right(assets);
    });
  }

  Future<Either<Notification, String>> addAsset(Asset newAsset) async {
    final validation = _validateAsset(newAsset, 'addAsset');
    if (validation.isLeft()) return validation;
    final Wallet wallet = _appData.getWalletById(newAsset.walletForeignKey)..addAsset(newAsset);
    if (!wallet.isValid) return Left(wallet.notifications.first);
    final checkResponse = await _saveOrGetSavedCompanyId(newAsset.company);
    if (checkResponse.isLeft()) return checkResponse;
    newAsset.company.setObjectId(checkResponse.getOrElse(null));
    final response = await _database.create(newAsset);
    return response.fold((notification) {
      _appData.getWalletById(newAsset.walletForeignKey).removeAsset(newAsset.objectId);
      return Left(notification);
    }, (objectId) {
      newAsset.setObjectId(objectId);
      return Right(objectId);
    });
  }

  Future<Either<Notification, Notification>> deleteAsset(String walletId, String assetId) async {
    if (!_appData.hasWallet(walletId))
      return Left(Notification('AssetsUseCase.deleteAsset', 'A carteira informada não foi localizada'));
    final Wallet wallet = _appData.getWalletById(walletId);
    wallet.removeAsset(assetId);
    if (!wallet.isValid) return Left(wallet.notifications.first);
    return await _database.delete(assetId);
  }

  Future<Either<Notification, Notification>> updateAsset(Asset newAsset) async {
    final validation = _validateAsset(newAsset, 'updateAsset');
    if (validation.isLeft()) return validation.fold((notification) => Left(notification), (r) => null);
    final Asset originalAsset = _appData.findAsset(newAsset.objectId);
    if (originalAsset == null)
      return Left(Notification('AssetUseCase.updateAsset', 'O ativo informado não foi encontrado'));
    final Wallet originalWallet = _appData.getWalletById(originalAsset.walletForeignKey);
    if (originalWallet.objectId != newAsset.walletForeignKey)
      return Left(Notification('AssetUseCase.updateAsset', 'Não é possível alterar a carteira de um ativo'));
    final response = await _database.update(newAsset);
    return response.fold((notification) => Left(notification), (notification2) {
      originalWallet.updateAsset(newAsset);
      return Right(notification2);
    });
  }

  Either<Notification, String> _validateAsset(Asset newAsset, String method) {
    if (newAsset == null || !newAsset.isValid || newAsset.company == null)
      return Left(Notification('AssetUseCase.$method', 'Um ativo inválido não pode ser salvo'));
    if (!_appData.hasWallet(newAsset.walletForeignKey))
      return Left(Notification('AssetsUseCase.$method', 'A carteira informada não foi localizada'));
    if (!_appData.hasCategory(newAsset?.category?.objectId))
      return Left(Notification('AssetsUseCase.$method', 'A categoria informada não foi localizada'));
    return Right('');
  }

  Future<Either<Notification, String>> _saveOrGetSavedCompanyId(Company company) async {
    final response = await _database.filterByProperties(Company, ['ticker'], [company.ticker]);
    if (response.isLeft()) return response.fold((notification) => Left(notification), (r) => null);
    final List<Company> result = List<Company>.from(response.getOrElse(() => []));
    if (result.length != 0) return Right(result.first.objectId);

    final response2 = await _database.create(company);
    return response2.fold((notification) => Left(notification), (objectId) => Right(objectId));
  }
}
