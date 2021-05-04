import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/database_repository.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/app_client_database_mock.dart';

main() {
  AppData appData;
  AssetsUseCase assetsUSeCase;
  Wallet mainWallet;
  Wallet otherWallet;

  setUpAll(() async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    AppClientDatabaseMock client = AppClientDatabaseMock();
    DatabaseServiceAgreement databaseService = ParseDatabaseService(client: client);
    DatabaseRepositoryAgreement database = DatabaseRepository(databaseService);
    appData = AppData()..updateCurrentUser(User(null, null, Name('Michel', 'Scheeren'), Email('michel@gmail.com')));
    assetsUSeCase = AssetsUseCase(database, appData);
    await WalletsUseCase(database, appData).getAllUserWallets();
    mainWallet = appData.wallets.firstWhere((e) => e.isMainWallet);
    otherWallet = appData.wallets.firstWhere((e) => !e.isMainWallet);
  });

  group('Tests about AssetsUseCase.getAssets', () {
    test('should return Left when send null wallet', () async {
      final response = await assetsUSeCase.getAssets(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when not found wallet', () async {
      final response = await assetsUSeCase.getAssets('12345');
      expect(response.isLeft(), isTrue);
    });

    test('should return Right when valid wallet', () async {
      final response = await assetsUSeCase.getAssets(mainWallet.objectId);
      expect(response.isRight(), isTrue);
    });

    test('wallet should contain assets after succes getAssets', () async {
      expect(mainWallet.assets.isNotEmpty, isTrue);
    });
  });
}
