import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/database_repository.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/app_client_database_mock.dart';

main() {
  AppData appData;
  AssetsUseCase assetsUseCase;
  Wallet mainWallet, otherWallet;
  Company company1, company2;
  Category category1, category2, category3;

  setUpAll(() async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    AppClientDatabaseMock client = AppClientDatabaseMock();
    DatabaseServiceAgreement databaseService = ParseDatabaseService(client: client);
    DatabaseRepositoryAgreement database = DatabaseRepository(databaseService);
    appData = AppData()..updateCurrentUser(User(null, null, Name('Michel', 'Scheeren'), Email('michel@gmail.com')));
    assetsUseCase = AssetsUseCase(database, appData);
    await WalletsUseCase(database, appData).getAllUserWallets();
    mainWallet = appData.wallets.firstWhere((e) => e.isMainWallet);
    otherWallet = appData.wallets.firstWhere((e) => !e.isMainWallet);
    company1 = Company(null, null, 'ITUB3', 'ITUB3:BZ', 'BRL', 'Americas', 'Itaú', 'Common Stock', 'B3', 'Brasil');
    company2 = Company(null, null, 'PSSA3', 'PSSA3:BZ', 'BRL', 'Americas', 'PS', 'Common Stock', 'B3', 'Brasil');
    category1 = Category(null, null, 'Cripto', 9);
    category2 = Category('qnB4cH9sJs', null, 'Ação', 0);
    category3 = Category('ukhIcvLzZl', null, 'Fii', 1);
    appData.registerCategories([category2]);
  });

  group('Tests about AssetsUseCase.getAssets', () {
    test('should return Left when send null wallet', () async {
      final response = await assetsUseCase.getAssets(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when not found wallet', () async {
      final response = await assetsUseCase.getAssets('12345');
      expect(response.isLeft(), isTrue);
    });

    test('should return Right when valid wallet', () async {
      final response = await assetsUseCase.getAssets(mainWallet.objectId);
      expect(response.isRight(), isTrue);
    });

    test('wallet should contain assets after succes getAssets', () async {
      expect(mainWallet.assets.isNotEmpty, isTrue);
    });
  });

  group('Tests about AssetsUseCase.addAsset', () {
    test('should return Left when send null asset ', () async {
      final response = await assetsUseCase.addAsset(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when send invalid asset ', () async {
      Asset asset1 = Asset(null, null, null, null, Amount(100), Score(10), Quantity(2), 'Avc');
      final response = await assetsUseCase.addAsset(asset1);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when send  asset without invalid category', () async {
      Asset asset1 = Asset(null, null, company1, category1, Amount(100), Score(10), Quantity(2), mainWallet.objectId);
      final response = await assetsUseCase.addAsset(asset1);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A categoria informada não foi localizada');
    });

    test('should return Left when send  asset that cannot be valid to add', () async {
      var aux1 = Asset('INBOMkNhQE', null, company1, category2, Amount(1), Score(1), Quantity(2), mainWallet.objectId);
      final response = await assetsUseCase.addAsset(aux1);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Não é possivel adicionar itens duplicados');
    });

    test('should return Right when valid asset to add', () async {
      var aux1 = Asset('ABCZ', null, company1, category2, Amount(1), Score(1), Quantity(2), mainWallet.objectId);
      int initialLength = appData.wallets.first.assets.length;
      final response = await assetsUseCase.addAsset(aux1);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.first.assets.length, initialLength + 1);
    });
  });

  group('Tests about AssetsUseCase.deleteAsset', () {
    test('should return Left when send null value', () async {
      final response = await assetsUseCase.deleteAsset(null, null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when send invalid wallet key', () async {
      final response = await assetsUseCase.deleteAsset('1793', null);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A carteira informada não foi localizada');
    });

    test('should return Left when send invalid asset key', () async {
      final response = await assetsUseCase.deleteAsset(mainWallet.objectId, '145687');
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'O item não existe na lista');
    });

    test('should return Right and remove when send valid data', () async {
      int initialLength = appData.wallets.first.assets.length;
      final response = await assetsUseCase.deleteAsset(mainWallet.objectId, '2Idh2KIgrc');
      expect(response.isRight(), isTrue);
      expect(appData.wallets.first.assets.length, initialLength - 1);
    });
  });

  group('Tests about AssetsUseCase.updateAsset', () {
    test('should return Left when send asset that not exists', () async {
      var aux1 = Asset(null, null, company1, category2, Amount(1), Score(1), Quantity(2), mainWallet.objectId);
      final response = await assetsUseCase.updateAsset(aux1);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'O ativo informado não foi encontrado');
    });

    test('should return Right when try update correct asset', () async {
      final Wallet wallet = appData.wallets.first;
      final Asset asset = wallet.assets.first;
      asset.setWalletForeignKey(wallet.objectId);
      asset.quantity.setValue(999);
      final response = await assetsUseCase.updateAsset(asset);
      expect(response.isRight(), isTrue);
    });
  });
}
