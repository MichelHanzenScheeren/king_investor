import 'package:king_investor/domain/models/company.dart';

class CompanyConverter {
  Company fromMapToModel(Map map) {
    return Company(
      map['objectId'],
      map['createdAt'],
      map['symbol'],
      map['ticker'],
      map['currency'],
      map['region'],
      map['name'],
      map['securityType'],
      map['exchange'],
      map['country'],
    );
  }
}
