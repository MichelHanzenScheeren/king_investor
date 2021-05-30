import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class WalletsUseCase {
  late DatabaseRepositoryAgreement _database;
  late AppData _appData;

  WalletsUseCase(DatabaseRepositoryAgreement database, AppData appData) {
    _database = database;
    _appData = appData;
  }

  Future<Either<Notification, List<Wallet>>> getAllUserWallets() async {
    if (_appData.currentUserId.isEmpty) return Left(Notification('WalletsUseCase.getWallets', 'Usuário indisponível'));
    if (_appData.wallets.isNotEmpty) return Right(_appData.wallets);
    final response = await _database.filterByRelation(Wallet, [User], [_appData.currentUserId]);
    return response.fold(
      (notification) => Left(notification),
      (resultList) async {
        final List<Wallet> newWallets = List<Wallet>.from(resultList);
        if (newWallets.isEmpty) return await _createAndRegisterMainWallet();
        _appData.registerWallets(newWallets);
        return Right(_appData.wallets);
      },
    );
  }

  Future<Either<Notification, List<Wallet>>> _createAndRegisterMainWallet() async {
    final Wallet mainWallet = Wallet.createMainWallet(_appData.currentUserId);
    final response = await _database.create(mainWallet);
    return response.fold(
      (notification) => Left(notification),
      (notification2) {
        _appData.registerWallets([mainWallet]);
        return Right(_appData.wallets);
      },
    );
  }

  Future<Either<Notification, Notification?>> addWallet(Wallet? newWallet) async {
    final validate = _validateWalletToAdd(newWallet);
    if (validate.isLeft()) return validate;
    final response = await _database.create(newWallet!);
    return response.fold(
      (notification) => Left(notification),
      (notification2) {
        _appData.registerWallets([newWallet]);
        return Right(notification2);
      },
    );
  }

  Future<Either<Notification, Notification>> deleteWallet(String? walletId) async {
    final validate = _validateWalletToDelete(walletId);
    if (validate.isLeft()) return validate;
    final Wallet wallet = _appData.getWalletById(walletId!);
    final response = await _database.delete(wallet);
    return response.fold(
      (notification1) => Left(notification1),
      (notification2) {
        _appData.deleteWallet(wallet);
        return Right(notification2);
      },
    );
  }

  Future<Either<Notification, Notification>> updateWallet(Wallet? wallet) async {
    final validate = _validateWalletToUpdate(wallet);
    if (validate.isLeft()) return validate;
    final response = await _database.update(wallet!);
    return response.fold(
      (notification1) => Left(notification1),
      (notification2) {
        _appData.updateWallet(wallet);
        return Right(notification2);
      },
    );
  }

  Future<Either<Notification, Notification>> changeMainWallet(String? newMainWalletId) async {
    final validate = _validateWalletsToChangeMainWallet(newMainWalletId);
    if (validate.isLeft()) return validate;
    final validate2 = await _setCurrentMainWallet();
    if (validate2.isLeft()) return validate2;

    final Wallet newMainWallet = _appData.getWalletById(newMainWalletId!);
    newMainWallet.setMainWallet(true);
    final response2 = await _database.update(newMainWallet);
    return response2.fold(
      (notification1) => Left(notification1),
      (notification2) => Right(notification2),
    );
  }

  Either<Notification, Notification> _validateWalletToAdd(Wallet? wallet) {
    if (wallet == null || !wallet.isValid)
      return Left(Notification('WalletsUseCase.addWallet', 'Uma carteira inválida não pode ser salva'));
    if (_appData.containWallet(wallet.objectId))
      return Left(Notification('WalletsUseCase.addWallet', 'Não é possível adicionar uma carteira duplicada'));
    if (_appData.duplicatedMainWallet(wallet))
      return Left(Notification('WalletsUseCase.addWallet', 'Não é possível registrar duas carteiras principais'));
    return Right(Notification('', ''));
  }

  Either<Notification, Notification> _validateWalletToDelete(String? walletId) {
    if (!_appData.containWallet(walletId))
      return Left(Notification('WalletsUseCase.deleteWallet', 'Carteira não encontrada'));
    if (_appData.getWalletById(walletId!).isMainWallet)
      return Left(Notification('WalletsUseCase.deleteWallet', 'Não é possível apagar a carteira principal'));
    return Right(Notification('', ''));
  }

  Either<Notification, Notification> _validateWalletToUpdate(Wallet? wallet) {
    if (wallet == null || !wallet.isValid)
      return Left(Notification('WalletsUseCase.editWallet', 'Uma carteira inválida não pode ser editada'));
    if (!_appData.containWallet(wallet.objectId))
      return Left(Notification('WalletsUseCase.editWallet', 'Carteira não encontrada'));
    final Wallet originalWallet = _appData.getWalletById(wallet.objectId);
    if (wallet.isMainWallet != originalWallet.isMainWallet)
      return Left(Notification('WalletsUseCase.editWallet', 'Método inválido paa mudar a carteira principal'));
    return Right(Notification('', ''));
  }

  Either<Notification, Notification> _validateWalletsToChangeMainWallet(String? newMainWalletId) {
    if (!_appData.containWallet(newMainWalletId))
      return Left(Notification('WalletsUseCase.changeMainWallet', 'Carteira não encontrada'));
    if (_appData.getMainWallet().objectId == newMainWalletId)
      return Left(Notification('WalletsUseCase.changeMainWallet', 'Esta já é a carteira principal'));
    return Right(Notification('', ''));
  }

  Future<Either<Notification, Notification>> _setCurrentMainWallet() async {
    final Wallet oldMainWallet = _appData.getMainWallet();
    oldMainWallet.setMainWallet(false);
    final response1 = await _database.update(oldMainWallet);
    if (response1.isLeft()) return response1;
    return Right(Notification('', ''));
  }
}
