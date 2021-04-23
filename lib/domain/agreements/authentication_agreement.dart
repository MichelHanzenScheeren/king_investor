import 'package:dartz/dartz.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class AuthenticationAgreement {
  Future<Either<Notification, String>> signUp(String email, String password, Map userData);
  Future<Either<Notification, Map>> login(String email, String password);
  Future<Either<Notification, Notification>> logout();
  Future<Either<Notification, Map>> currentUser();
  Future<Either<Notification, Map>> validateCurrentUser();
}
