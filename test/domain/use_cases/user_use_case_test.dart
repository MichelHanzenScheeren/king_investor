import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/authentication_repository.dart';
import 'package:king_investor/data/services/parse_authentication_service.dart';
import 'package:king_investor/domain/agreements/authentication_repository_agreement.dart';
import 'package:king_investor/domain/agreements/authentication_service_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mocks/app_client_authentication_mock.dart';
import '../../static/authentication_response.dart';

main() {
  late AuthenticationRepositoryAgreement authentication;
  late AppData appData;
  late UserUseCase userUseCase;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
    final String currentUser = kLoginSucessResponseJSON;
    SharedPreferences.setMockInitialValues(<String, String>{'flutter_parse_sdk_user': currentUser});
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    AppClientAuthenticationMock client = AppClientAuthenticationMock();
    AuthenticationServiceAgreement authenticationService = ParseAuthenticationService(client: client);
    authentication = AuthenticationRepository(authenticationService);
  });

  group('tests about function signUp of UserUseCase', () {
    setUpAll(() async {
      appData = AppData();
      userUseCase = UserUseCase(authentication, appData);
    });

    test('Should do correct signUp', () async {
      User user = User('12345678', null, Name('Michel', 'Scheeren'), Email('michel@gmail.com'));
      final response = await userUseCase.signUp(user, 'ABCDEF');
      expect(response.getOrElse(() => Object as User), isInstanceOf<User>());
      expect(appData.currentUser, response.getOrElse(() => Object as User));
      expect(appData.currentUser!.sessionToken, 'r:acc24187bc16109398c5a2fad2f06d0a');
    });

    test('Expect "wasUpdated" is true and "wallets" is empty after signup', () async {
      expect(appData.wasUpdated, isTrue);
      expect(appData.wallets.isEmpty, isTrue);
    });

    test('Should return Left when try signup with user logged', () async {
      User user = User('987654', null, Name('Vinicius', 'Scheeren'), Email('vinicius@gmail.com'));
      final response = await userUseCase.signUp(user, 'ABCDEF');
      expect(response.isLeft(), isTrue);
      response.fold((l) => expect(l.message.contains('Já existe um usuário'), isTrue), (r) => expect(isTrue, isFalse));
    });
  });

  group('tests about function login of UserUseCase', () {
    setUpAll(() async {
      appData = AppData();
      userUseCase = UserUseCase(authentication, appData);
    });

    test('Should do correct login', () async {
      final response = await userUseCase.login('michel@gmail.com', 'ABCDEF');
      expect(response.getOrElse(() => Object as User), isInstanceOf<User>());
      expect(appData.currentUser, response.getOrElse(() => Object as User));
      expect(appData.currentUser!.sessionToken, 'r:acc24187bc16109398c5a2fad2f06d0a');
    });

    test('Expect "wasUpdated" is true and "wallets" is empty after login', () async {
      expect(appData.wasUpdated, isTrue);
      expect(appData.wallets.isEmpty, isTrue);
    });

    test('Should return Left when try login with user logged', () async {
      final response = await userUseCase.login('michel@gmail.com', 'ABCDEF');
      expect(response.isLeft(), isTrue);
      response.fold((l) => expect(l.message.contains('Já existe um usuário'), isTrue), (r) => expect(isTrue, isFalse));
    });
  });

  group('tests about function currentUser of UserUseCase', () {
    setUpAll(() async {
      appData = AppData();
      userUseCase = UserUseCase(authentication, appData);
    });

    test('Should obtain correct User and update him', () async {
      final response = await userUseCase.currentUser();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => Object as User), isInstanceOf<User>());
    });

    test('Expect AppData properties is ok after logout', () async {
      expect(appData.currentUser!.name.firstName, 'Michel');
      expect(appData.wasUpdated, isTrue);
      expect(appData.wallets.isEmpty, isTrue);
    });
  });

  group('tests about function logout of UserUseCase', () {
    setUpAll(() async {
      appData = AppData();
      userUseCase = UserUseCase(authentication, appData);
    });

    test('Should do correct logout', () async {
      await userUseCase.login('michel@gmail.com', 'ABCDEF');
      final response = await userUseCase.logout();
      expect(response.isRight(), isTrue);
    });

    test('Expect AppData properties is ok after logout', () async {
      expect(appData.currentUser, null);
      expect(appData.wasUpdated, isFalse);
      expect(appData.wallets.isEmpty, isTrue);
    });

    test('Should return left when try logout without user logged', () async {
      final response = await userUseCase.logout();
      expect(response.isLeft(), isTrue);
    });
  });
}
