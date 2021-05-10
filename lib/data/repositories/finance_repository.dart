import 'package:dartz/dartz.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/data/converters/exchange_rate_converter.dart';
import 'package:king_investor/data/converters/price_converter.dart';
import 'package:king_investor/domain/agreements/finance_agreement.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/resources/keys.dart';

class FinanceRepository implements FinanceAgreement {
  RequestAgreement _requestService;

  FinanceRepository(RequestAgreement requestService) {
    _requestService = requestService;
    _configureRequestService();
  }

  void _configureRequestService() {
    _requestService.configureRequests(
      headers: <String, dynamic>{
        'x-rapidapi-host': 'bloomberg-market-and-financial-news.p.rapidapi.com',
        'x-rapidapi-key': kBloombergKey,
      },
      baseUrl: 'https://bloomberg-market-and-financial-news.p.rapidapi.com/market',
    );
  }

  @override
  Future<Either<Notification, List<Company>>> search(String query) async {
    final response = await _requestService.request('/auto-complete?query=$query');
    return response.fold(
      (notification) => Left(notification),
      (map) => Right(_convertToCompaniesList(map)),
    );
  }

  @override
  Future<Either<Notification, List<Price>>> getPrices(List<String> tickers) async {
    String symbols = '';
    tickers?.forEach((e) => symbols += ',' + e);
    final response = await _requestService.request('/get-compact?id=${symbols.replaceFirst(",", "")}');
    return response.fold(
      (notification) => Left(notification),
      (map) => Right(_convertToPricesList(map)),
    );
  }

  @override
  Future<Either<Notification, ExchangeRate>> getExchangeRate(String origin, String destiny) async {
    final response = await _requestService.request('get-cross-currencies?id=$origin,$destiny');
    return response.fold(
      (notification) => Left(notification),
      (map) => Right(_convertToExchangeRate(map, origin, destiny)),
    );
  }

  List<Company> _convertToCompaniesList(Map map) {
    List<Company> list = [];
    List<Map> results = List.castFrom(map['quote']);
    results.forEach((e) => list.add(CompanyConverter().fromMapToModel(e)));
    return list;
  }

  List<Price> _convertToPricesList(Map map) {
    List<Price> list = [];
    Map results = map['result'];
    results.keys.forEach((key) => list.add(PriceConverter().fromMapToModel(results[key])));
    return list;
  }

  ExchangeRate _convertToExchangeRate(Map map, String origin, String destiny) {
    Map result = map['result'];
    return ExchangeRateConverter().fromMapToModel(result['$origin$destiny:cur']);
  }
}
