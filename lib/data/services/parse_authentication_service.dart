import 'package:dartz/dartz.dart';
import 'package:king_investor/data/utils/parse_exception.dart';
import 'package:king_investor/domain/agreements/authentication_service_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseAuthenticationService implements AuthenticationServiceAgreement {
  @override
  Future<Either<Notification, dynamic>> signUp(
    String email,
    String password,
    Map userData,
  ) async {
    try {
      ParseUser parseUser = ParseUser(email, password, email);
      userData.keys.forEach((key) => parseUser.set(key, userData[key]));
      parseUser.setACL(ParseACL()..setPublicReadAccess(allowed: false));
      final response = await parseUser.signUp();
      if (response.success) return Right(parseUser);
      return _error('ParseAuthenticationService.signUp', ParseException.getDescription((response.statusCode)));
    } catch (erro) {
      return _error('ParseAuthenticationService.signUp', erro.toString());
    }
  }

  @override
  Future<Either<Notification, dynamic>> login(String email, String password) async {
    try {
      ParseUser parseUser = ParseUser(email, password, email);
      final response = await parseUser.login();
      if (response.success) return Right(response.results.first);
      return _error('ParseAuthenticationService.login', ParseException.getDescription((response.statusCode)));
    } catch (erro) {
      return _error('ParseAuthenticationService.login', erro.toString());
    }
  }

  @override
  Future<Either<Notification, Notification>> logout() async {
    try {
      ParseUser user = await ParseUser.currentUser();
      final response = await user.logout();
      if (response.success) return Right(Notification('ParseAuthenticationService.logout', 'Logout concluído'));
      return _error('ParseAuthenticationService.logout', ParseException.getDescription((response.statusCode)));
    } catch (erro) {
      return _error('ParseAuthenticationService.logout', erro.toString());
    }
  }

  @override
  Future<Either<Notification, dynamic>> currentUser() async {
    try {
      final user = await ParseUser.currentUser();
      if (user != null) return Right(user);
      return Left(Notification('ParseAuthenticationService.currentUser', 'Nenhum usuário encontrado'));
    } catch (erro) {
      return _error('ParseAuthenticationService.currentUser', erro.toString());
    }
  }

  @override
  Future<Either<Notification, dynamic>> updateCurrentUser(String sessionToken) async {
    try {
      final response = await ParseUser.getCurrentUserFromServer(sessionToken);
      if (response.success) return Right(response.results.first);
      return _error(
        'ParseAuthenticationService.updateCurrentUser',
        ParseException.getDescription((response.statusCode)),
      );
    } catch (erro) {
      return _error('ParseAuthenticationService.updateCurrentUser', erro.toString());
    }
  }

  Either<Notification, dynamic> _error(String key, String message) {
    return Left(Notification(key, message));
  }
}
