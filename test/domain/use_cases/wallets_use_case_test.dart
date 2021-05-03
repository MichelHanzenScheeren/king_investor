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

  group('Tests aboud WaletsUseCase', () {
    setUpAll(() async {
      await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
      AppClientDatabaseMock client = AppClientDatabaseMock();
      DatabaseServiceAgreement databaseService = ParseDatabaseService(client: client);
      database = DatabaseRepository(databaseService);
      appData = AppData()..updateCurrentUser(User(null, null, Name('Michel', 'Scheeren'), Email('michel@gmail.com')));
      walletsUseCase = WalletsUseCase(database, appData);
    });

    // test('should create a valid MainWallet when empty', () async {
    //   final response = await walletsUseCase.getWallets();
    //   expect(response.isRight(), isTrue);
    //   expect(response.getOrElse(() => null), isInstanceOf<List<Wallet>>());
    //   expect(response.getOrElse(() => null).length, 1);
    //   expect(response.getOrElse(() => null).first.name, 'Principal');
    //   expect(response.getOrElse(() => null).first.isMainWallet, true);
    // });

    test('should return a valid list of Wallets', () async {
      final response = await walletsUseCase.getWallets();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => null), isInstanceOf<List<Wallet>>());
      expect(response.getOrElse(() => null).length, 2);
      expect(appData.wallets.length, 2);
    });

    test('should return Left when try add null', () async {
      final response = await walletsUseCase.addWallet(null);
      expect(response.isLeft(), isTrue);
      expect(appData.wallets.length, 2);
    });

    test('should return Left when try add invalid wallet', () async {
      Wallet wallet = Wallet.createMainWallet('123456');
      wallet.addAsset(null); // will invalidate the wallet
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isLeft(), isTrue);
      expect(appData.wallets.length, 2);
    });

    test('should return Left when try add repeated wallet', () async {
      Wallet wallet = Wallet('7jgnYX0BBi', null, false, 'Teste', '123456');
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isLeft(), isTrue);
      expect(appData.wallets.length, 2);
    });

    test('should return Left when try add repeated main wallet', () async {
      Wallet wallet = Wallet('abcy', null, true, 'Teste', '123456');
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isLeft(), isTrue);
      expect(appData.wallets.length, 2);
    });

    test('should return Right(String) when add valid wallet', () async {
      Wallet wallet = Wallet('abcy', null, false, 'Teste', '123456');
      final response = await walletsUseCase.addWallet(wallet);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.length, 3);
    });
  });
}
