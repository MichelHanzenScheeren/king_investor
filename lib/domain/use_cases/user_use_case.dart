import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/authentication_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class UserUseCase {
  AuthenticationRepositoryAgreement _authentication;
  AppData _appData;

  UserUseCase(AuthenticationRepositoryAgreement authentication, AppData appData) {
    _authentication = authentication;
    _appData = appData;
  }

  bool get wasUpdated => _appData.wasUpdated;

  Future<Either<Notification, User>> signUp(User user, String password) async {
    if (_appData.currentUser != null)
      return Left(Notification('UserUseCase.signUp', 'Já existe um usuário conectado. Faça logout e tente novamente'));
    final response = await _authentication.signUp(user, password);
    return response.fold((notification) => Left(notification), (loggedUser) {
      _appData.updateCurrentUser(loggedUser);
      return Right(loggedUser);
    });
  }

  Future<Either<Notification, User>> login(String email, String password) async {
    if (_appData.currentUser != null)
      return Left(Notification('UserUseCase.login', 'Já existe um usuário conectado. Faça logout e tente novamente'));
    final response = await _authentication.login(email, password);
    return response.fold((notification) => Left(notification), (loggedUser) {
      _appData.updateCurrentUser(loggedUser);
      return Right(loggedUser);
    });
  }

  Future<Either<Notification, Notification>> logout() async {
    if (_appData.currentUser == null)
      return Left(Notification('UserUseCase.logout', 'Nenhum usuário conectado atualmente'));
    final response = await _authentication.logout();
    return response.fold((notification) => Left(notification), (notification2) {
      _appData.removeCurrentUser();
      return Right(notification2);
    });
  }

  Future<Either<Notification, User>> currentUser() async {
    if (_appData.currentUser == null) {
      final response = await _authentication.currentUser();
      return response.fold((notification) => Left(notification), (user) async {
        _appData.registerUser(user);
        if (!_appData.wasUpdated) return updateCurrentUser(user.sessionToken);
        return Right(user);
      });
    }
    return Future.value(Right(_appData.currentUser));
  }

  Future<Either<Notification, User>> updateCurrentUser(String sessionToken) async {
    final response = await _authentication.updateCurrentUser(sessionToken);
    return response.fold((notification) {
      if (notification.message.contains('Sessão inválida')) _appData.removeCurrentUser();
      return Left(notification);
    }, (updatedUser) {
      _appData.updateCurrentUser(updatedUser);
      return Right(updatedUser);
    });
  }
}
