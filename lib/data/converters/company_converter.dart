import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/company.dart';

class CompanyConverter {
  Company fromMapToModel(Map map) {
    return Company(
      map[kObjectId],
      map[kCreatedAt],
      map[kSymbol],
      map[kTicker],
      map[kCurrency],
      map[kRegion],
      map[kName],
      map[kSecurityType],
      map[kExchange],
      map[kCountry],
    );
  }

  Map fromModelToMap(Company company) {
    return {
      kObjectId: company.objectId,
      kCreatedAt: company.createdAt,
      kSymbol: company.symbol,
      kTicker: company.ticker,
      kCurrency: company.currency,
      kRegion: company.region,
      kName: company.name,
      kSecurityType: company.securityType,
      kExchange: company.exchange,
      kCountry: company.country,
    };
  }
}
