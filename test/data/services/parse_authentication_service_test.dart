import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/services/parse_authentication_service.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/agreements/authentication_service_agreement.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mocks/parse_http_client_mock.dart';
import '../../static/statics.dart';

main() async {
  ParseHTTPClientMock httpClientMock;
  AuthenticationServiceAgreement authentication;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
    final String currentUser = await rootBundle.loadString(kParseLoginSuccessResponse);
    SharedPreferences.setMockInitialValues(<String, String>{'flutter_parse_sdk_user': currentUser});
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    httpClientMock = ParseHTTPClientMock();
    authentication = ParseAuthenticationService(client: httpClientMock);
  });

  group('Test ParseAuthenticationService.signup(emai, password, map)', () {
    test('should return Right(dynamic) when success signup', () async {
      final expected = await rootBundle.loadString(kParseSignupSuccessResponse);
      httpClientMock.defineResponse(response: expected, statusCode: 201);
      final response = await authentication.signUp('any', 'any', {});
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(null).get(kObjectId), 'nr7hAYS43a');
    });
    test('should return Left(Notification) when invalid signup', () async {
      final expected = '{"code": 202, "error": "A"}';
      httpClientMock.defineResponse(response: expected, statusCode: 400);
      final response = await authentication.signUp('any', 'any', {});
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Já existe uma conta cadastrada com este endereço de e-mail'), null);
    });
  });

  group('Test ParseAuthenticationService.login(emai, password)', () {
    test('should return Right(dynamic) when success login', () async {
      final expected = await rootBundle.loadString(kParseLoginSuccessResponse);
      httpClientMock.defineResponse(response: expected, statusCode: 200);
      final response = await authentication.login('any', 'any');
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(null).get(kObjectId), 'ySHIHT13xA');
    });
    test('should return Left(Notification) when invalid login', () async {
      final expected = '{"code": 101, "error": "Invalid username/password"}';
      httpClientMock.defineResponse(response: expected, statusCode: 404);
      final response = await authentication.login('any', 'any');
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Usuário/senha inválido'), null);
    });
  });

  group('Test ParseAuthenticationService.currentUser() and logout():', () {
    test('should return Right(dynamic) when there is user logged in', () async {
      final response = await authentication.currentUser();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(null).get('sessionToken'), 'r:acc24187bc16109398c5a2fad2f06d0a');
    });
    test('should return Right(Notification) when do logout and there is user logged in', () async {
      httpClientMock.defineResponse(response: '{}', statusCode: 200);
      final response = await authentication.logout();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(null).message, 'Logout concluído');
    });
    test('should return Left(Notification) when there is not user logged in', () async {
      final response = await authentication.currentUser();
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Nenhum usuário encontrado'), null);
    });
    test('should return Left(Notification) when do logout and there is no user logged in', () async {
      httpClientMock.defineResponse(response: '{"code": 101, "error": "A"}', statusCode: 404);
      final response = await authentication.logout();
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Nenhum usuário conectado'), null);
    });
  });

  group('Test ParseAuthenticationService.updateCurrentUser()', () {
    test('should return Left(Notification) when invalid sessionToken', () async {
      httpClientMock.defineResponse(response: '{"code": 209, "error": "A"}', statusCode: 400);
      final response = await authentication.updateCurrentUser('A');
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Sessão inválida (InvalidSessionToken)'), null);
    });

    test('should return Right(dynamic) when valid sessionToken', () async {
      final expected = await rootBundle.loadString(kParseSignupSuccessResponse);
      httpClientMock.defineResponse(response: expected, statusCode: 200);
      final response = await authentication.updateCurrentUser('r:acc24187bc16109398c5a2fad2f06d0a');
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(null).get(kObjectId), 'nr7hAYS43a');
    });
  });
}
