import 'package:dartz/dartz.dart';
import 'package:king_investor/data/converters/user_converter.dart';
import 'package:king_investor/domain/agreements/authentication_repository_agreement.dart';
import 'package:king_investor/domain/agreements/authentication_service_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:king_investor/domain/models/user.dart';

class AuthenticationRepository implements AuthenticationRepositoryAgreement {
  AuthenticationServiceAgreement _authentication;

  AuthenticationRepository(AuthenticationServiceAgreement authentication) {
    _authentication = authentication;
  }

  @override
  Future<Either<Notification, User>> signUp(User user, String password) async {
    try {
      Map userData = UserConverter().fromModelToMap(user);
      final response = await _authentication.signUp(user.email.address, password, userData);
      return _buildResponse(response);
    } catch (erro) {
      return Left(_getError('signUp', erro));
    }
  }

  @override
  Future<Either<Notification, User>> login(String email, String password) async {
    try {
      final response = await _authentication.login(email, password);
      return _buildResponse(response);
    } catch (erro) {
      return Left(_getError('login', erro));
    }
  }

  @override
  Future<Either<Notification, Notification>> logout() async {
    return await _authentication.logout();
  }

  @override
  Future<Either<Notification, User>> currentUser() async {
    try {
      final response = await _authentication.currentUser();
      return _buildResponse(response);
    } catch (erro) {
      return Left(_getError('currentUser', erro));
    }
  }

  @override
  Future<Either<Notification, User>> updateCurrentUser(String sessionToken) async {
    try {
      final response = await _authentication.updateCurrentUser(sessionToken);
      return _buildResponse(response);
    } catch (erro) {
      return Left(_getError('currentUser', erro));
    }
  }

  @override
  Future<Either<Notification, Notification>> updateUserData(User user) async {
    try {
      Map userData = UserConverter().fromModelToMap(user);
      return await _authentication.updateUserData(userData);
    } catch (erro) {
      return Left(_getError('currentUser', erro));
    }
  }

  @override
  Future<Either<Notification, Notification>> requestPasswordReset(String email) async {
    try {
      return await _authentication.requestPasswordReset(email);
    } catch (erro) {
      return Left(_getError('currentUser', erro));
    }
  }

  Either<Notification, User> _buildResponse(Either<Notification, dynamic> response) {
    return response.fold(
      (notification) => Left(notification),
      (mapUser) => Right(mapUser == null ? null : UserConverter().fromMapToModel(mapUser)),
    );
  }

  Notification _getError(String key, dynamic erro) {
    return Notification('AuthenticationRepository.$key', 'Um erro inesperado ocorreu. (' + erro.toString() + ')');
  }
}
