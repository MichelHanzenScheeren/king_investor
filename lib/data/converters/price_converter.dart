import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';

const kObjectId = 'objectId';
const kCreatedAt = 'createdAt';
const kTicker = 'ticker';
const kLastUpdate = 'lastPriceTime';
const kVolume = 'volume';
const kVariation = 'pctChange';
const kMonthVariation = 'pctChange1M';
const kYearVariation = 'pctChangeYTD';
const kLastPrice = 'last';
const kDayHigh = 'dayHigh';
const kDayLow = 'dayLow';
const kYearHigh = 'yearHigh';
const kYearLow = 'yearLow';

class PriceConverter {
  Price fromMapToModel(Map map) {
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
