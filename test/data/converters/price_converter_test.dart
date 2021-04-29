import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/price_converter.dart';
import 'package:king_investor/domain/models/price.dart';
import '../../static/statics.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  final responseData = Map.from(json.decode(await rootBundle.loadString(kGetPricesJsonPath)));
  Map<String, dynamic> map = responseData['result']['PSSA3:BZ'];

  test('Should return valid Price when use fromMapToModel(map)', () {
    Price item = PriceConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.ticker, 'pssa3:bz');
    expect(item.volume.value, 661000.0);
  });
}
