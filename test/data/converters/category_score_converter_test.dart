import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/category_score_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

main() {
  test('Should return valid CategoryScore when use fromMapToModel(map)', () async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    final category = ParseObject(kCategoryTable)..set(kObjectId, 'qnB4cH9sJs')..set(kName, 'Ação')..set(kOrder, 0);
    final wallet = ParseObject(kWalletTable)..set(kObjectId, 'MlZIPMNohV');
    final map = ParseObject(kCategoryScoreTable)..set(kObjectId, 'cxgmtUYfM4')..set(kCreatedAt, DateTime(2021, 4, 22));
    map..set(kScore, 10)..set(kCategory, category)..set(kWallet, wallet);
    CategoryScore item = CategoryScoreConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.score.value, 10);
    expect(item.walletForeignKey, 'MlZIPMNohV');
    expect(item.category.name, 'Ação');
    expect(item.category.objectId, 'qnB4cH9sJs');
  });

  test('Should return valid Map when use fromModelToMap(model)', () {
    final category = Category('789', null, 'Ação', 0);
    CategoryScore categoryScore = CategoryScore('12345', DateTime(2021, 04, 22), Score(10), category, 'MlZIPMNohV');
    Map map = CategoryScoreConverter().fromModelToMap(categoryScore);

    expect(map[kObjectId], '12345');
    expect(map[kCreatedAt], DateTime(2021, 04, 22));
    expect(map[kScore], 10);
    expect(map[kCategoryForeignKey], '789');
    expect(map[kWalletForeignKey], 'MlZIPMNohV');
  });
}
