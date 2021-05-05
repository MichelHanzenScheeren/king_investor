import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import '../static/exchange_rate_response.dart';
import '../static/prices_response.dart';
import '../static/search_response.dart';

class AppRequestServiceSimulated implements RequestAgreement {
  @override
  void configureRequests({
    int conectTimeoutMiliseconds: 5000,
    int sendTimeoutMiliseconds: 5000,
    int receiveTimeoutMiliseconds: 10000,
    Map headers,
    String baseUrl: '',
  }) {}

  @override
  Future<Either<Notification, Map>> request(String url) async {
    if (url.contains('auto-complete')) {
      return Future.value(Right(kSearchResponseMap));
    } else if (url.contains('get-compact')) {
      return Future.value(Right(kPricesResponseMap));
    } else if (url.contains('USD')) {
      return Future.value(Right(kExchangeRateResponseMap));
    } else {
      return Future.value(Left(Notification('request_service.unkown', 'Erro desconhecido')));
    }
  }
}
