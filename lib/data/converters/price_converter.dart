import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';

class PriceConverter {
  Price fromMapToModel(map) {
    return Price(
      map[kObjectId],
      map[kCreatedAt],
      map[kTicker],
      map[kLastUpdate],
      Amount(map[kVolume]),
      Amount.fromString(map[kVariation]),
      Amount.fromString(map[kMonthVariation]),
      Amount.fromString(map[kYearVariation]),
      Amount.fromString(map[kLastPrice]),
      Amount.fromString(map[kDayHigh]),
      Amount.fromString(map[kDayLow]),
      Amount.fromString(map[kYearHigh]),
      Amount.fromString(map[kYearLow]),
    );
  }
}
