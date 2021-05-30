import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class AssetsUseCase {
  late DatabaseRepositoryAgreement _database;
  late AppData _appData;

  AssetsUseCase(DatabaseRepositoryAgreement database, AppData appData) {
    _database = database;
    _appData = appData;
  }

  Future<Either<Notification, List<Asset>>> getAssets(String walletId) async {
    if (!_appData.containWallet(walletId))
      return Left(Notification('AssetsUseCase.getAssets', 'A carteira informada não foi localizada'));
    final Wallet wallet = _appData.getWalletById(walletId);
    if (wallet.assets.isNotEmpty) return Right(wallet.assets);

    final toInclude = <Type>[Company, Category];
    final response = await _database.filterByRelation(Asset, [Wallet], [walletId], include: toInclude);
    return response.fold(
      (notification) => Left(notification),
      (list) {
        final List<Asset> assets = List<Asset>.from(list);
        assets.forEach((asset) => wallet.isValidAssetToAdd(asset) ? wallet.addAsset(asset) : null);
        return Right(wallet.assets);
      },
    );
  }

  Future<Either<Notification, Notification>> addAsset(Asset? newAsset) async {
    final validation = _validateAssetToAdd(newAsset);
    if (validation.isLeft()) return validation;

    final saveCompanyResponse = await (_saveOrGetSavedCompanyId(newAsset!.company));
    if (saveCompanyResponse.isLeft())
      return Left(saveCompanyResponse.fold((notif) => notif, (r) => Notification('', '')));
    newAsset.company.setObjectId(saveCompanyResponse.getOrElse(() => ''));
    final response = await _database.create(newAsset);
    return response.fold(
      (notification) => Left(notification),
      (notification2) {
        _appData.getWalletById(newAsset.walletForeignKey).addAsset(newAsset);
        return Right(notification2);
      },
    );
  }

  Future<Either<Notification, Notification>> deleteAsset(String walletId, String assetId) async {
    if (!_appData.containWallet(walletId))
      return Left(Notification('AssetsUseCase.deleteAsset', 'A carteira informada não foi localizada'));
    final Wallet wallet = _appData.getWalletById(walletId);
    if (!wallet.isValidAssetToManipulate(assetId)) return Left(wallet.notifications.first);
    final response = await _database.delete(wallet.getAsset(assetId));
    return response.fold(
      (notification) => Left(notification),
      (notification2) {
        wallet.removeAsset(assetId);
        return Right(notification2);
      },
    );
  }

  Future<Either<Notification, Notification>> updateAsset(Asset? newAsset) async {
    final validation = _validateAssetToUpdate(newAsset);
    if (validation.isLeft()) return validation;
    final response = await _database.update(newAsset!);
    return response.fold((notification) => Left(notification), (notification2) {
      _localUpdateWallet(newAsset);
      return Right(notification2);
    });
  }

  Either<Notification, Notification> _validateAssetToAdd(Asset? asset) {
    if (asset == null || !asset.isValid)
      return Left(Notification('AssetUseCase.addAsset', 'Nã é possível cadastrar um ativo inválido'));
    if (!_appData.containWallet(asset.walletForeignKey))
      return Left(Notification('AssetsUseCase.addAsset', 'A carteira informada não foi localizada'));
    if (!_appData.containCategory(asset.category.objectId))
      return Left(Notification('AssetsUseCase.addAsset', 'A categoria informada não foi localizada'));
    final Wallet wallet = _appData.getWalletById(asset.walletForeignKey);
    if (!wallet.isValidAssetToAdd(asset)) return Left(wallet.notifications.first);
    return Right(Notification('', ''));
  }

  Future<Either<Notification, String>> _saveOrGetSavedCompanyId(Company company) async {
    final response = await _database.filterByProperties(Company, ['ticker'], [company.ticker]);
    if (response.isLeft()) return response.fold((notification) => Left(notification), (r) => Right(''));
    final List<Company> result = List<Company>.from(response.getOrElse(() => []));
    if (result.length != 0) return Right(result.first.objectId);

    final response2 = await _database.create(company);
    return response2.fold((notification) => Left(notification), (notification2) => Right(company.objectId));
  }

  Either<Notification, Notification> _validateAssetToUpdate(Asset? asset) {
    if (asset == null || !asset.isValid)
      return Left(Notification('AssetUseCase.updateAsset', 'Não é possível editar um ativo inválido'));
    if (!_appData.containWallet(asset.walletForeignKey))
      return Left(Notification('AssetsUseCase.updateAsset', 'A carteira informada não foi localizada'));
    if (!_appData.containCategory(asset.category.objectId))
      return Left(Notification('AssetsUseCase.updateAsset', 'A categoria informada não foi localizada'));
    final Asset? originalAsset = _appData.findAsset(asset.objectId);
    if (originalAsset == null)
      return Left(Notification('AssetUseCase.updateAsset', 'O ativo informado não foi encontrado'));
    final Wallet newWallet = _appData.getWalletById(asset.walletForeignKey);
    final Wallet originalWallet = _appData.getWalletById(originalAsset.walletForeignKey);
    if (originalWallet.objectId != newWallet.objectId && !newWallet.isValidAssetToAdd(asset))
      return Left(Notification('AssetUseCase.updateAsset', 'Não é possível adicionar o ativo a esta carteira'));
    return Right(Notification('', ''));
  }

  void _localUpdateWallet(Asset asset) {
    final Asset originalAsset = _appData.findAsset(asset.objectId)!;
    final Wallet newWallet = _appData.getWalletById(asset.walletForeignKey);
    final Wallet originalWallet = _appData.getWalletById(originalAsset.walletForeignKey);
    if (originalWallet.objectId != newWallet.objectId) {
      newWallet.addAsset(asset);
      originalWallet.removeAsset(asset.objectId);
    } else {
      originalWallet.updateAsset(asset);
    }
  }
}
