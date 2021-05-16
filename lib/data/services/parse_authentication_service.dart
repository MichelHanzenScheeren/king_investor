import 'package:dartz/dartz.dart';
import 'package:king_investor/data/utils/parse_exception.dart';
import 'package:king_investor/domain/agreements/authentication_service_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseAuthenticationService implements AuthenticationServiceAgreement {
  ParseClient _client;

  ParseAuthenticationService({ParseClient client}) {
    _client = client ?? ParseHTTPClient();
  }

  @override
  Future<Either<Notification, dynamic>> signUp(String email, String password, Map userData) async {
    try {
      ParseUser parseUser = ParseUser(email, password, email, client: _client);
      userData.keys.forEach((key) => parseUser.set(key, userData[key]));
      parseUser.setACL(ParseACL()..setPublicReadAccess(allowed: false));
      final response = await parseUser.signUp();
      if (response.success) return Right(parseUser);
      return Left(_error('signUp', ParseException.getDescription((response.statusCode))));
    } catch (erro) {
      return Left(_error('signUp', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, dynamic>> login(String email, String password) async {
    try {
      ParseUser parseUser = ParseUser(email, password, email, client: _client);
      final response = await parseUser.login();
      if (response.success) return Right(response.results.first);
      return Left(_error('login', ParseException.getDescription((response.statusCode))));
    } catch (erro) {
      return Left(_error('login', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> logout() async {
    try {
      final current = await ParseUser.currentUser();
      if (current == null) return Left(_error('logout', 'Nenhum usuário conectado'));
      final user = ParseUser('', '', '', client: _client)..sessionToken = current['sessionToken'];
      final response = await user.logout();
      if (response.success) return Right(Notification('ParseAuthenticationService.logout', 'Logout concluído'));
      return Left(_error('logout', ParseException.getDescription((response.statusCode))));
    } catch (erro) {
      return Left(_error('logout', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, dynamic>> currentUser() async {
    try {
      final user = await ParseUser.currentUser();
      return Right(user);
    } catch (erro) {
      return Left(_error('currentUser', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, dynamic>> updateCurrentUser(String sessionToken) async {
    try {
      final response = await ParseUser.getCurrentUserFromServer(sessionToken, client: _client);
      if (response.success) return Right(response.results.first);
      return Left(_error('updateCurrentUser', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(_error('updateCurrentUser', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> updateUserData(Map userData) async {
    try {
      final response = await currentUser();
      if (response.isLeft()) return Left(_error('updateUserData', 'Não foi possível obter o usuário atual'));
      String sessionToken = response.getOrElse(() => null)['sessionToken'];
      final response2 = await ParseUser.getCurrentUserFromServer(sessionToken, client: _client);
      if (!response2.success) return Left(_error('updateUserData', 'Não foi possível atualizar o usuário atual'));
      final ParseUser current = response2.results.first;
      userData.keys.forEach((key) => current.set(key, userData[key]));
      final response3 = await current.save();
      if (response3.success) return Right(_error('updateUserData', 'Alterações salvas'));
      return Left(_error('updateUserData', ParseException.getDescription(response3.statusCode)));
    } catch (erro) {
      return Left(_error('updateUserData', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> requestPasswordReset() async {
    try {
      final ParseUser auxUser = await ParseUser.currentUser();
      if (auxUser == null) return Left(_error('resetPassword', 'Não foi possível obter o usuário atual'));
      final ParseUser current = ParseUser(auxUser.username, auxUser.password, auxUser.emailAddress, client: _client);
      current.sessionToken = auxUser.sessionToken;
      final response2 = await current.requestPasswordReset();
      if (response2.success)
        return Right(_error('resetPassword', 'Um email com instruções de redefinição foi enviado.'));
      return Left(_error('resetPassword', ParseException.getDescription(response2.statusCode)));
    } catch (erro) {
      return Left(_error('resetPassword', erro.toString()));
    }
  }

  Notification _error(String key, String message) {
    return Notification('ParseAuthenticationService.$key', message);
  }
}
