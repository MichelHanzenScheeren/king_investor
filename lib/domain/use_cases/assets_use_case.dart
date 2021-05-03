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
    if (newAsset == null || !newAsset.isValid)
      return Left(Notification('AssetUseCase.addAsset', 'Um ativo inválido não pode ser salvo'));
    if (!_appData.hasWallet(newAsset.walletForeignKey))
      return Left(Notification('AssetsUseCase.addAsset', 'A carteira informada não foi localizada'));
    final Wallet wallet = _appData.getWalletById(newAsset.walletForeignKey);
    wallet.addAsset(newAsset);
    if (!wallet.isValid) return Left(wallet.notifications.first);

    final response = await _database.create(newAsset);
    return response.fold((notification) {
      wallet.removeAsset(newAsset.objectId);
      return Left(notification);
    }, (id) {
      newAsset.setObjectId(id);
      return Right(id);
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
}
