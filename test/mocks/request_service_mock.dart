import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';

import '../static/statics.dart';

class RequestServiceMock implements RequestAgreement {
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
      final responseData = Map.from(json.decode(await rootBundle.loadString(kSearchJsonPath)));
      return Future.value(Right(responseData));
    } else if (url.contains('get-compact')) {
      return Future.value(Right({}));
    } else if (url.contains('USD')) {
      return Future.value(Right({}));
    } else {
      return Future.value(Left(Notification('request_service.unkown', 'Erro desconhecido')));
    }
  }
}
