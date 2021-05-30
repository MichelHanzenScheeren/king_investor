import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/company.dart';
import '../../static/search_response.dart';

main() async {
  Map<String, dynamic> map = kSearchResponseMap['quote']![0];

  test('Should return valid Company when use fromMapToModel(map)', () {
    Company item = CompanyConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.ticker, 'pssa3:bz');
    expect(item.exchange, 'B3');
  });

  test('Should return valid Map when use fromModelToLongMap(model)', () {
    Company item = Company('A', null, 'B3SA3', 'B3SA3:BZ', 'BRL', '', 'B3 bolsa', 'Ação', 'B3 Day', 'Brazil');
    Map converter = CompanyConverter().fromModelToMap(item);
    expect(converter, isInstanceOf<Map>());
    expect(converter.length, 10);
    expect(converter[kObjectId], item.objectId);
    expect(converter[kTicker], item.ticker);
    expect(converter[kExchange], 'B3');
    expect(converter[kCountry], 'Brasil');
  });
}
