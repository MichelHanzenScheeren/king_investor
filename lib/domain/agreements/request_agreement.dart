import 'package:dartz/dartz.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class RequestAgreement {
  void configureRequests({
    int conectTimeoutMiliseconds: 5000,
    int sendTimeoutMiliseconds: 5000,
    int receiveTimeoutMiliseconds: 10000,
    Map<String, dynamic> headers,
    String baseUrl: '',
  });

  Future<Either<Notification, Map>> request(String url);
}
