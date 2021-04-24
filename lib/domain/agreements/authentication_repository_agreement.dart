import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class AuthenticationRepositoryAgreement {
  Future<Either<Notification, User>> signUp(User user, String password);
  Future<Either<Notification, User>> login(String email, String password);
  Future<Either<Notification, Notification>> logout();
  Future<Either<Notification, User>> currentUser();
  Future<Either<Notification, User>> updateCurrentUser(String sessionToken);
}
