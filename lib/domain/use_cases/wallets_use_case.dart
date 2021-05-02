import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class WalletsUseCase {
  DatabaseRepositoryAgreement _database;
  AppData _appData;

  WalletsUseCase(DatabaseRepositoryAgreement database, AppData appData) {
    _database = database;
    _appData = appData;
  }

  Future<Either<Notification, List<Wallet>>> getWallets() async {
    if (_appData.currentUserId.isEmpty) return Left(Notification('WalletsUseCase.getWallets', 'Usuário indisponível'));
    if (_appData.wallets.isNotEmpty) return Right(_appData.wallets);
    final response = await _database.filterByRelation(Wallet, [User], [_appData.currentUserId]);
    return response.fold((notification) => Left(notification), (resultList) async {
      final List<Wallet> newWallets = List<Wallet>.from(resultList);
      if (newWallets.isEmpty) return await _createAndRegisterMainWallet();
      _appData.registerWallets(newWallets);
      return Right(_appData.wallets);
    });
  }

  Future<Either<Notification, List<Wallet>>> _createAndRegisterMainWallet() async {
    final Wallet mainWallet = Wallet.createMainWallet(_appData.currentUserId);
    final response = await _database.create(mainWallet);
    return response.fold((notification) => Left(notification), (id) {
      mainWallet.setObjectId(id);
      _appData.registerWallets([mainWallet]);
      return Right(_appData.wallets);
    });
  }

  Future<Either<Notification, String>> addWallet(Wallet newWallet) async {
    if (newWallet == null || !newWallet.isValid)
      return Left(Notification('WalletsUseCase.addWallet', 'Uma carteira inválida não pode ser salva'));
    if (_appData.hasWallet(newWallet.objectId))
      return Left(Notification('WalletsUseCase.addWallet', 'Não é possível adicionar uma carteira duplicada'));
    if (_appData.duplicatedMainWallet(newWallet))
      return Left(Notification('WalletsUseCase.addWallet', 'Não é possível registrar duas carteiras principais'));
    final response = await _database.create(newWallet);
    return response.fold((notification) => Left(notification), (objectId) {
      newWallet.setObjectId(objectId);
      _appData.registerWallets([newWallet]);
      return Right(objectId);
    });
  }

  Future<Either<Notification, Notification>> deleteWallet(String walletId) async {
    if (!_appData.hasWallet(walletId))
      return Left(Notification('WalletsUseCase.deleteWallet', 'Carteira não encontrada'));
    final Wallet wallet = _appData.getWalletById(walletId);
    if (wallet.isMainWallet)
      return Left(Notification('WalletsUseCase.deleteWallet', 'Não é possível apagar a carteira principal'));
    final response = await _database.delete(wallet);
    return response.fold((notification1) => Left(notification1), (notification2) {
      _appData.deleteWallet(wallet);
      return Right(notification2);
    });
  }

  Future<Either<Notification, Notification>> updateWallet(Wallet wallet) async {
    if (wallet == null || !wallet.isValid)
      return Left(Notification('WalletsUseCase.editWallet', 'Uma carteira inválida não pode ser editada'));
    if (!_appData.hasWallet(wallet.objectId))
      return Left(Notification('WalletsUseCase.editWallet', 'Carteira não encontrada'));
    final Wallet originalWallet = _appData.getWalletById(wallet?.objectId);
    if (wallet.isMainWallet != originalWallet.isMainWallet)
      return Left(Notification('WalletsUseCase.editWallet', 'Não é possível editar esta carteira'));
    final response = await _database.update(wallet);
    return response.fold((notification1) => Left(notification1), (notification2) {
      _appData.updateWallet(wallet);
      return Right(notification2);
    });
  }

  Future<Either<Notification, Notification>> changeMainWallet(String newMainWalletId) async {
    if (!_appData.hasWallet(newMainWalletId))
      return Left(Notification('WalletsUseCase.changeMainWallet', 'Carteira não encontrada'));
    final Wallet newMainWallet = _appData.getWalletById(newMainWalletId);
    final Wallet oldMainWallet = _appData.getMainWallet();
    if (oldMainWallet != null) {
      oldMainWallet.setMainWallet(false);
      final response1 = await _database.update(oldMainWallet);
      if (response1.isLeft()) return response1;
      _appData.updateWallet(oldMainWallet);
    }
    newMainWallet.setMainWallet(true);
    final response2 = await _database.update(newMainWallet);
    return response2.fold((notification1) => Left(notification1), (notification2) {
      _appData.updateWallet(newMainWallet);
      return Left(notification2);
    });
  }
}
