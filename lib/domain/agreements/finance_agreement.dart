import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class FinanceAgreement {
  Future<Either<Notification, List<Company>>> search(String query);
  Future<Either<Notification, List<Price>>> getPrices(List<String> tickers);
  Future<Either<Notification, ExchangeRate>> getExchangeRate(String origin, String destiny);
}
