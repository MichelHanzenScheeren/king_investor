import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/category_converter.dart';
import 'package:king_investor/domain/models/category.dart';

import '../../static/statics.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  final map = Map.from(json.decode(await rootBundle.loadString(kCategoryJsonPath)));

  test('Should return valid Category when use fromMapToModel(map)', () {
    Category item = CategoryConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.order, 1);
    expect(item.name, 'Fii');
    expect(item.score.value, 10);
  });
}
