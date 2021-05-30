import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import '../../static/search_response.dart';

main() async {
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
    late Map companies;
    late Company company1;
    late Company company2;
    late Category category1;
    late Category category2;
    late Asset asset1;
    late Asset asset2;
    late Wallet wallet;

    setUpAll(() async {
      companies = kSearchResponseMap;
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

    test('should be invalid and return false when send duplicated asset to method isValidAssetToAdd ', () {
      wallet.addAsset(asset1);
      wallet.isValidAssetToAdd(asset1);
      expect(wallet.isValid, isFalse);
      expect(wallet.assets.length, 1);
    });

    test('should throw error when try add duplicated asset', () {
      wallet.addAsset(asset1);
      expect(() => wallet.addAsset(asset1), throwsException);
      expect(wallet.assets.length, 1);
    });

    test('should be invalid and return false when send null to method isValidAssetToAdd ', () {
      wallet.isValidAssetToAdd(null);
      expect(wallet.isValid, isFalse);
    });

    test('should be invalid and return false when send invalid asset to method isValidAssetToAdd ', () {
      Asset asset3 = Asset('1', null, company1, category1, Amount(100.0), Score(-5), Quantity(5), '1234');
      wallet.isValidAssetToAdd(asset3);
      expect(wallet.isValid, isFalse);
    });

    test('should be valid when try to remove valid asset', () {
      wallet.addAsset(asset1);
      wallet.removeAsset(asset1.objectId);
      expect(wallet.isValid, isTrue);
      expect(wallet.assets.length, 0);
    });

    test('should be invalid and return false when send asset that not exists to isValidAssetToManipulate', () {
      wallet.isValidAssetToManipulate(asset2.objectId);
      expect(wallet.isValid, isFalse);
    });

    test('should throw error when try to remove invalid asset', () {
      expect(() => wallet.removeAsset(asset2.objectId), throwsException);
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

    test('should throws Exception when try to update invalid asset', () {
      wallet.addAsset(asset1);
      expect(() => wallet.updateAsset(asset2), throwsException);
    });
  });
}
