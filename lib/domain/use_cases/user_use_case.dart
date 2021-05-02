import 'dart:collection';
import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/authentication_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class UserUseCase {
  AuthenticationRepositoryAgreement _authentication;
  AppData _appData;
  final List<Notification> _messages = <Notification>[];

  UserUseCase(AuthenticationRepositoryAgreement authentication, AppData appData) {
    _authentication = authentication;
    _appData = appData;
  }

  bool get wasUpdated => _appData.wasUpdated;

  UnmodifiableListView<Notification> get messages => UnmodifiableListView<Notification>(_messages);

  Future<Either<Notification, User>> signUp(User user, String password) async {
    final response = await _authentication.signUp(user, password);
    return response.fold((notification) => Left(notification), (user) {
      _appData.registerNewUser(user);
      return Right(user);
    });
  }

  Future<Either<Notification, User>> login(String email, String password) async {
    final response = await _authentication.login(email, password);
    return response.fold((notification) => Left(notification), (user) {
      _appData.registerNewUser(user);
      return Right(user);
    });
  }

  Future<Either<Notification, Notification>> logout() async {
    final response = await _authentication.logout();
    return response.fold((notification) => Left(notification), (notification2) {
      _appData.removeCurrentUser();
      return Right(notification2);
    });
  }

  Future<Either<Notification, User>> currentUser() async {
    if (_appData.currentUser == null) {
      final response = await _authentication.currentUser();
      return response.fold((notification) => Left(notification), (user) {
        _appData.registerNewUser(user);
        updateCurrentUser(user.sessionToken);
        return Right(user);
      });
    }
    return Future.value(Right(_appData.currentUser));
  }

  Future<Either<Notification, User>> updateCurrentUser(String sessionToken) async {
    final response = await _authentication.updateCurrentUser(sessionToken);
    return response.fold((notification) {
      _messages.add(notification);
      return Left(notification);
    }, (updatedUser) {
      _appData.updateCurrentUser(updatedUser);
      _messages.clear();
      return Right(updatedUser);
    });
  }
}
