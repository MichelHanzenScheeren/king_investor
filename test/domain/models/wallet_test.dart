import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import '../../static/statics.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets

  test('should create a valid main Wallet when use Wallet.createMainWallet()', () {
    final wallet = Wallet.createMainWallet('1234');
    expect(wallet.isValid, isTrue);
    expect(wallet.isMainWallet, isTrue);
    expect(wallet.name, 'Principal');
    expect(wallet.userForeignKey, '1234');
    expect(wallet.assets.length, 0);
  });

  test('should create a valid wallet when null name', () {
    final wallet = Wallet(null, null, false, null, '1234');
    expect(wallet.isValid, isTrue);
    expect(wallet.isMainWallet, isFalse);
    expect(wallet.name.contains('Nova Carteira'), isTrue);
    expect(wallet.assets.length, 0);
  });

  test('should create a valid wallet when empty name', () {
    final wallet = Wallet(null, null, false, ' ', '1234');
    expect(wallet.isValid, isTrue);
    expect(wallet.name.contains('Nova Carteira'), isTrue);
  });

  test('should create a valid wallet when null isMainWallet', () {
    final wallet = Wallet(null, null, null, 'Carteira 2', '1234');
    expect(wallet.isValid, isTrue);
    expect(wallet.isMainWallet, isFalse);
  });

  test('should create a valid wallet when valid data', () {
    final wallet = Wallet(null, null, true, 'Carteira 2', '1234');
    expect(wallet.isValid, isTrue);
    expect(wallet.isMainWallet, isTrue);
    expect(wallet.name, 'Carteira 2');
    expect(wallet.userForeignKey, '1234');
  });

  group('Tests about list of assets', () {
    Map companies;
    Company company1;
    Company company2;
    Category category1;
    Category category2;
    Asset asset1;
    Asset asset2;
    Wallet wallet;

    setUpAll(() async {
      companies = Map.from(json.decode(await rootBundle.loadString(kSearchJsonPath)));
      company1 = CompanyConverter().fromMapToModel(companies['quote'][0]);
      company2 = CompanyConverter().fromMapToModel(companies['quote'][1]);
      category1 = Category(null, null, 'Itausa', 0);
      category2 = Category(null, null, 'Itaú', 1);
      asset1 = Asset('1', null, company1, category1, Amount(100.0), Score(10), Quantity(5), '1234');
      asset2 = Asset('2', null, company2, category2, Amount(150.0), Score(9), Quantity(3), '1234');
    });

    setUp(() {
      wallet = Wallet.createMainWallet('1234');
    });

    test('should add two Assets', () {
      wallet.addAsset(asset1);
      wallet.addAsset(asset2);
      expect(wallet.isValid, isTrue);
      expect(wallet.assets.length, 2);
    });

    test('should be invalid when try add repeated asset', () {
      wallet.addAsset(asset1);
      wallet.addAsset(asset1);
      expect(wallet.isValid, isFalse);
      expect(wallet.assets.length, 1);
    });

    test('should be invalid when try add null asset', () {
      wallet.addAsset(null);
      expect(wallet.isValid, isFalse);
    });

    test('should be valid when try to remove valid asset', () {
      wallet.addAsset(asset1);
      wallet.removeAsset(asset1.objectId);
      expect(wallet.isValid, isTrue);
      expect(wallet.assets.length, 0);
    });

    test('should be invalid when try to remove invalid asset', () {
      wallet.removeAsset(asset2.objectId);
      expect(wallet.isValid, isFalse);
    });

    test('should return true when try find valid asset', () {
      wallet.addAsset(asset1);
      expect(wallet.hasAsset(asset1.objectId), isTrue);
    });

    test('should return false when try find invalid asset', () {
      expect(wallet.hasAsset(asset1.objectId), isFalse);
    });

    test('should be valid when try to update valid asset', () {
      wallet.addAsset(asset1);
      wallet.updateAsset(wallet.assets.first..quantity.setValue(999));
      expect(wallet.isValid, isTrue);
      expect(wallet.assets.first.quantity.value, 999);
    });

    test('should be invalid when try to update invalid asset', () {
      wallet.addAsset(asset1);
      wallet.updateAsset(asset2);
      expect(wallet.isValid, isFalse);
    });
  });
}
