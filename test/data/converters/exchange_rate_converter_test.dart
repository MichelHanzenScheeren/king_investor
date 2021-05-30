import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/exchange_rate_converter.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import '../../static/exchange_rate_response.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  final responseData = kExchangeRateResponseMap;
  Map<String, dynamic>? map = responseData['result']!['USDBRL:cur'];

  test('Should return valid Price when use fromMapToModel(map)', () {
    ExchangeRate item = ExchangeRateConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.origin, 'USD');
    expect(item.destiny, 'BRL');
    expect(item.lastPrice.value, 5.6490);
  });
}
