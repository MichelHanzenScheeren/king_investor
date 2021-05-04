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
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/app_client_database_mock.dart';

main() {
  DatabaseRepositoryAgreement database;
  AppData appData;
  AssetsUseCase assetsUseCase;
  Wallet wallet1, wallet2;
  Category category1, category2;

  setUpAll(() async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    AppClientDatabaseMock client = AppClientDatabaseMock();
    DatabaseServiceAgreement databaseService = ParseDatabaseService(client: client);
    database = DatabaseRepository(databaseService);
  });

  void groupSetUpAll() {
    appData = AppData();
    assetsUseCase = AssetsUseCase(database, appData);
    wallet1 = Wallet('wallet1_id', null, true, 'Principal', '1234567890');
    wallet2 = Wallet('wallet2_id', null, false, 'Secundária', '1234567890');
    category1 = Category('category1_id', null, 'Ação', 0);
    category2 = Category('category2_id', null, 'Fii', 1);
    appData.updateCurrentUser(User(null, null, Name('Michel', 'Scheeren'), Email('michel@gmail.com')));
    appData.registerWallets([wallet1, wallet2]);
    appData.registerCategories([category1, category2]);
  }

  group('Tests about AssetsUseCase.getAssets', () {
    setUpAll(() => groupSetUpAll());

    test('should return Left when send null wallet', () async {
      final response = await assetsUseCase.getAssets(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when not found wallet', () async {
      final response = await assetsUseCase.getAssets('12345');
      expect(response.isLeft(), isTrue);
    });

    test('should return Right when valid wallet', () async {
      final response = await assetsUseCase.getAssets(wallet1.objectId);
      expect(response.isRight(), isTrue);
    });

    test('wallet should contain assets after succes getAssets', () async {
      expect(wallet1.assets.isNotEmpty, isTrue);
    });
  });

  group('Tests about AssetsUseCase.addAsset', () {
    Company company1;
    Asset asset1;
    setUpAll(() {
      groupSetUpAll();
      company1 = Company('company1_id', null, 'ITUB3', 'ITUB3:BZ', 'BRL', 'A', 'Itaú', 'Ação', 'B3', 'Brasil');
      asset1 = Asset('asset1_id', null, company1, category1, Amount(100), Score(10), Quantity(2), wallet1.objectId);
    });

    test('should return Left when send null asset ', () async {
      final response = await assetsUseCase.addAsset(null);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when send invalid asset ', () async {
      Asset asset1 = Asset(null, null, null, null, Amount(100), Score(10), Quantity(2), 'Avc');
      final response = await assetsUseCase.addAsset(asset1);
      expect(response.isLeft(), isTrue);
    });

    test('should return Left when send asset with invalid category', () async {
      Category aux1 = Category('1234567', null, 'Bitcoin', 1); // categoria inválida
      Asset assetInvalid = Asset(null, null, company1, aux1, Amount(100), Score(10), Quantity(2), wallet1.objectId);
      final response = await assetsUseCase.addAsset(assetInvalid);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A categoria informada não foi localizada');
    });

    test('should return Right when valid asset to add', () async {
      int initialLength = appData.wallets.first.assets.length;
      final response = await assetsUseCase.addAsset(asset1);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.first.assets.length, initialLength + 1);
    });

    test('should return Left when send repeated asset', () async {
      final response = await assetsUseCase.addAsset(asset1);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Não é possivel adicionar itens duplicados');
    });
  });

  group('Tests about AssetsUseCase.deleteAsset', () {
    Company company1;
    Asset asset1;
    setUpAll(() {
      groupSetUpAll();
      company1 = Company('company1_id', null, 'ITUB3', 'ITUB3:BZ', 'BRL', 'A', 'Itaú', 'Ação', 'B3', 'Brasil');
      asset1 = Asset('asset1_id', null, company1, category1, Amount(100), Score(10), Quantity(2), wallet1.objectId);
      wallet1.addAsset(asset1);
    });

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
      final response = await assetsUseCase.deleteAsset(wallet1.objectId, '145687');
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'O item não existe na lista');
    });

    test('should return Right and remove when send valid data', () async {
      int initialLength = appData.wallets.first.assets.length;
      final response = await assetsUseCase.deleteAsset(wallet1.objectId, asset1.objectId);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.first.assets.length, initialLength - 1);
    });
  });

  group('Tests about AssetsUseCase.updateAsset', () {
    Company company1, company2;
    Asset asset1, asset2, asset3;
    setUpAll(() {
      groupSetUpAll();
      company1 = Company('company1_id', null, 'ITUB3', 'ITUB3:BZ', 'BRL', 'A', 'Itaú', 'Ação', 'B3', 'Brasil');
      company2 = Company('company2_id', null, 'PSSA3', 'PSSA3:BZ', 'BRL', 'A', 'Itaú', 'Ação', 'B3', 'Brasil');
      asset1 = Asset('asset1_id', null, company1, category1, Amount(100), Score(10), Quantity(2), wallet1.objectId);
      wallet1.addAsset(asset1);
      asset2 = Asset('asset2_id', null, company2, category1, Amount(100), Score(10), Quantity(2), wallet1.objectId);
      wallet1.addAsset(asset2);
      asset3 = Asset('asset3_id', null, company2, category1, Amount(200), Score(10), Quantity(5), wallet2.objectId);
      wallet2.addAsset(asset3);
    });

    test('should return Left when send null', () async {
      final response = await assetsUseCase.updateAsset(null);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Não é possível editar um ativo inválido');
    });

    test('should return Left when send asset with invalid wallet', () async {
      asset3.setWalletForeignKey('123456');
      final response = await assetsUseCase.updateAsset(asset3);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A carteira informada não foi localizada');
      asset3.setWalletForeignKey(wallet2.objectId);
    });

    //

    test('should return Left when send asset with invalid category', () async {
      Category invalid = Category('1234567', null, 'Bitcoin', 1); // categoria inválida
      asset3.setCategory(invalid);
      final response = await assetsUseCase.updateAsset(asset3);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A categoria informada não foi localizada');
      asset3.setCategory(category1);
    });

    test('should return Left when send asset was not saved', () async {
      Asset notSaved = Asset('15P', null, company2, category2, Amount(1), Score(5), Quantity(2), wallet1.objectId);
      final response = await assetsUseCase.updateAsset(notSaved);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'O ativo informado não foi encontrado');
    });

    test('should return Left when try change wallet of asset and newWallet not can save asset', () async {
      Asset aux = Asset('asset2_id', null, company2, category1, Amount(100), Score(10), Quantity(2), wallet2.objectId);
      final response = await assetsUseCase.updateAsset(aux);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Não é possível adicionar o ativo a esta carteira');
    });

    test('should return Right when try update correct asset', () async {
      Asset aux = Asset('asset2_id', null, company2, category1, Amount(999), Score(10), Quantity(2), wallet1.objectId);
      final response = await assetsUseCase.updateAsset(aux);
      expect(response.isRight(), isTrue);
      expect(appData.wallets.first.getAsset('asset2_id').averagePrice.value, 999);
    });

    test('should return Right when try change wallet of asset and is valid', () async {
      Asset aux = Asset('asset1_id', null, company1, category1, Amount(100), Score(10), Quantity(3), wallet2.objectId);
      int wallet1Lenght = appData.wallets[0].assets.length;
      int wallet2Lenght = appData.wallets[1].assets.length;
      final response = await assetsUseCase.updateAsset(aux);
      expect(response.isRight(), isTrue);
      expect(appData.wallets[0].assets.length, wallet1Lenght - 1);
      expect(appData.wallets[1].assets.length, wallet2Lenght + 1);
      expect(appData.findAsset('asset1_id')?.quantity?.value, 3);
    });
  });
}
