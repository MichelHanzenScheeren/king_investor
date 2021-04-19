import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';

class ExchangeRateConverter {
  ExchangeRate fromMapToModel(Map map) {
    String symbol = map[kSymbol] ?? '';
    String currency = map[kCurrency] ?? '';
    return ExchangeRate(
      map[kObjectId],
      map[kCreatedAt],
      symbol.replaceAll(currency, ''),
      currency,
      Amount.fromString(map[kLast]),
    );
  }
}
