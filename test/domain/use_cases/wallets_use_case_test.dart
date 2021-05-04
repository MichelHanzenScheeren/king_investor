import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/database_repository.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../../mocks/app_client_database_mock.dart';

main() {
  DatabaseRepositoryAgreement database;
  AppData appData;
  WalletsUseCase walletsUseCase;

  setUpAll(() async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    AppClientDatabaseMock client = AppClientDatabaseMock();
    DatabaseServiceAgreement databaseService = ParseDatabaseService(client: client);
    database = DatabaseRepository(databaseService);
    appData = AppData()..updateCurrentUser(User(null, null, Name('Michel', 'Scheeren'), Email('michel@gmail.com')));
    walletsUseCase = WalletsUseCase(database, appData);
  });

  group('Testes about WalletUseCase.getAll', () {
    /*test('should create a valid MainWallet when empty', () async {
      final response = await walletsUseCase.getWallets();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => null)?.length, 1);
      expect(response.getOrElse(() => null)?.first?.isMainWallet, true);
    });*/

    test('should return a valid list of Wallets', () async {
      final response = await walletsUseCase.getAllUserWallets();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => null), isInstanceOf<List<Wallet>>());
      expect(appData.wallets.isEmpty, isFalse);
    });
  });

  group('Tests aboud WaletsUseCase.addWallet', () {
    test('should return Left when try add null', () async {
      final response = await walletsUseCase.addWallet(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try add invalid wallet', () async {
      Wallet wallet = Wallet.createMainWallet('123456')..isValidAssetToAdd(null);
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try add repeated wallet', () async {
      Wallet wallet = Wallet('7jgnYX0BBi', null, false, 'Teste', '123456');
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try add repeated main wallet', () async {
      Wallet wallet = Wallet('abcy', null, true, 'Teste', '123456');
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isLeft(), isTrue);
    });

    test('should return Right(String) when add valid wallet', () async {
      Wallet wallet = Wallet('abcy', null, false, 'Teste', '123456');
      final int previousQuantity = appData.wallets.length;
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.length, previousQuantity + 1);
    });
  });

  group('Tests aboud WaletsUseCase.updateWallet', () {
    test('should return Left when try update null', () async {
      final response = await walletsUseCase.updateWallet(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try update invalid wallet', () async {
      Wallet wallet = Wallet.createMainWallet('123456')..isValidAssetToAdd(null);
      final response = await walletsUseCase.updateWallet(wallet);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try update property isMainWallet', () async {
      final response = await walletsUseCase.updateWallet(Wallet('7jgnYX0BBi', null, false, 'A', '1234'));
      expect(response.isLeft(), isTrue);
    });

    test('should return Right(Notification) when update valid wallet', () async {
      Wallet wallet = Wallet('7jgnYX0BBi', null, true, 'Teste sucesso', '123456');
      final response = await walletsUseCase.updateWallet(wallet);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.first.name, 'Teste sucesso');
    });
  });

  group('Tests aboud WaletsUseCase.deleteWallet', () {
    test('should return Left when try to delete null wallet', () async {
      final response = await walletsUseCase.deleteWallet(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try to delete null wallet', () async {
      final response = await walletsUseCase.deleteWallet('ABCDE');
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try to delete main wallet', () async {
      final response = await walletsUseCase.deleteWallet('7jgnYX0BBi');
      expect(response.isLeft(), isTrue);
    });

    test('should return Right when delete valid wallet', () async {
      final int previousLegth = appData.wallets.length;
      final response = await walletsUseCase.deleteWallet('sI92wSvh9l');
      expect(response.isRight(), isTrue);
      expect(appData.wallets.length, previousLegth - 1);
    });
  });

  group('Tests aboud WaletsUseCase.changeMainWallet', () {
    test('should return Left when try changeMainWallet whit wallet that does not exists', () async {
      final response = await walletsUseCase.changeMainWallet('1097');
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when try changeMainWallet whit current mainWallet', () async {
      final response = await walletsUseCase.changeMainWallet('7jgnYX0BBi');
      expect(response.isLeft(), isTrue);
    });

    // test('should return Right when try changeMainWallet whit valid new mainWallet', () async {
    //   String auxWalletId = (await walletsUseCase.addWallet(Wallet(null, null, false, 'Olá', '2345'))).getOrElse(null);
    //   final response = await walletsUseCase.changeMainWallet(auxWalletId);
    //   expect(response.isRight(), isTrue);
    //   expect(appData.getMainWallet().objectId, auxWalletId);
    // });
  });
}
