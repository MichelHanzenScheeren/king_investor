import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/category_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

main() {
  test('Should return valid Category when use fromMapToModel(map)', () async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    final parse = ParseObject(kCategoryTable)..set(kObjectId, 'ukhIcvLzZl')..set(kCreatedAt, DateTime(2021, 4, 21));
    parse..set(kName, 'Fii')..set(kOrder, 1);
    Category item = CategoryConverter().fromMapToModel(parse);
    expect(item.isValid, true);
    expect(item.order, 1);
    expect(item.name, 'Fii');
  });
}
