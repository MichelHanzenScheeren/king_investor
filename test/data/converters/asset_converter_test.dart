import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/asset_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

main() {
  test('Should return valid Asset when use fromMapToModel(map)', () async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    final category = ParseObject(kCategoryTable)..set(kObjectId, 'qnB4cH9sJs')..set(kName, 'Ação')..set(kOrder, 0);
    final company = ParseObject(kCompanyTable)..set(kObjectId, 'Nentyg4662')..set(kSymbol, 'PSSA3');
    company..set(kTicker, 'pssa3:bz')..set(kCurrency, 'BRL');
    final wallet = ParseObject(kWalletTable)..set(kObjectId, 'MlZIPMNohV');

    final map = ParseObject(kAssetTable)..set(kObjectId, 'INBOMkNhQE')..set(kAveragePrice, 45.04)..set(kScore, 10);
    map..set(kQuantity, 5)..set(kCompany, company)..set(kCategory, category)..set(kWallet, wallet);
    // map..set(kSales, Amount(0.0))..set(kIncomes, Amount())

    Asset item = AssetConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.objectId, 'INBOMkNhQE');
    expect(item.averagePrice.value, 45.04);
    expect(item.score.value, 10);
    expect(item.quantity.value, 5);
    expect(item.company.symbol, 'PSSA3');
    expect(item.company.ticker, 'pssa3:bz');
    expect(item.company.currency, 'BRL');
    expect(item.category.name, 'Ação');
    expect(item.walletForeignKey, 'MlZIPMNohV');
  });

  test('Should return valid Map when use fromModelToMap(model)', () {
    final category = Category('6789', null, 'Ação', 0);
    final company = Company('9876', null, '', '', '', '', '', '', '', '');
    Asset asset = Asset('1234', null, company, category, Amount(10), Score(10), Quantity(0), '5678');
    Map map = AssetConverter().fromModelToMap(asset);
    expect(map[kObjectId], '1234');
    expect(map[kCategoryForeignKey], '6789');
    expect(map[kCompanyForeignKey], '9876');
    expect(map[kWalletForeignKey], '5678');
    expect(map.containsKey('categoryForeignKey'), isTrue);
    expect(map.containsKey('companyForeignKey'), isTrue);
    expect(map.containsKey('walletForeignKey'), isTrue);
  });
}
