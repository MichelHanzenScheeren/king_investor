import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';

const kObjectId = 'objectId';
const kCreatedAt = 'createdAt';
const kSymbol = 'symbol';
const kCurrency = 'currency';
const kLast = 'last';

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
