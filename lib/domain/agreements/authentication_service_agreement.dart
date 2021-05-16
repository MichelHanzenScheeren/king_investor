import 'package:dartz/dartz.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class AuthenticationServiceAgreement {
  Future<Either<Notification, dynamic>> signUp(String email, String password, Map userData);
  Future<Either<Notification, dynamic>> login(String email, String password);
  Future<Either<Notification, Notification>> logout();
  Future<Either<Notification, dynamic>> currentUser();
  Future<Either<Notification, dynamic>> updateCurrentUser(String sessionToken);
  Future<Either<Notification, Notification>> updateUserData(Map userData);
}
