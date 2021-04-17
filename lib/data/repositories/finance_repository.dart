import 'package:dartz/dartz.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/domain/agreements/finance_agreement.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/static/keys.dart';

class FinanceRepository implements FinanceAgreement {
  RequestAgreement _requestService;

  FinanceRepository(RequestAgreement requestService) {
    _requestService = requestService;
    _configureRequestService();
  }

  void _configureRequestService() {
    _requestService.configureRequests(
      headers: {
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
  Future<Either<Notification, List<Price>>> getPrices(List<String> ticker) {
    // TODO: implement getPrices
    throw UnimplementedError();
  }

  @override
  Future<Either<Notification, ExchangeRate>> getExchangeRate(String origin, String destiny) {
    // TODO: implement getExchangeRate
    throw UnimplementedError();
  }

  List<Company> _convertToCompaniesList(Map<String, dynamic> map) {
    List<Company> list = [];
    List<Map> results = List.castFrom(map['quote']);
    results.forEach((e) => list.add(CompanyConverter().fromMapToModel(e)));
    return list;
  }
}
