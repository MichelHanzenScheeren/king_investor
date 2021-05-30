import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/parse_http_client_mock.dart';
import '../../static/wallets_response.dart';

main() async {
  ParseHTTPClientMock? httpClientMock;
  late DatabaseServiceAgreement database;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    httpClientMock = ParseHTTPClientMock();
    database = ParseDatabaseService(client: httpClientMock);
  });

  group('Test ParseDatabaseService.create(table, map)', () {
    test('should return Right(Notification) when success create response', () async {
      final expectedCreateResponse = {"objectId": "UgXo8hOD4d", "createdAt": "2021-04-21T17:19:30.598Z"};
      httpClientMock!.defineResponse(response: expectedCreateResponse, statusCode: 200);
      final response = await database.create('any', {});
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => Notification('', '')).message, 'Item salvo com sucesso');
    });
    test('should return Left(Notification) when error to create object', () async {
      httpClientMock!.defineResponse(response: {"code": 103}, statusCode: 103);
      final response = await database.create('any', {});
      expect(response.isLeft(), isTrue);
      response.fold(
        (notification) => expect(notification.message, 'Nome da Classe inválida (InvalidClassName)'),
        (map) => false,
      );
    });
  });

  group('Test ParseDatabaseService.update(table, map)', () {
    test('should return Right(Notification) when success create response', () async {
      final expectedCreateResponse = {"updatedAt": "2011-08-21T18:02:52.248Z"};
      httpClientMock!.defineResponse(response: expectedCreateResponse, statusCode: 200);
      final response = await database.update('any', {});
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => Notification('', '')).message, 'Item editado com sucesso');
      expect(response.getOrElse(() => Notification('', '')).key, 'ParseDatabaseService.edit');
    });
    test('should return Left(Notification) when error to create object', () async {
      final expectedResponse = {"code": 101, "error": "Object not found."};
      httpClientMock!.defineResponse(response: expectedResponse, statusCode: 404);
      final response = await database.update('any', {});
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Usuário/senha inválido'), (map) => false);
    });
  });

  group('Test ParseDatabaseService.delete(table, objectId)', () {
    test('should return Right(Notification) when success delete', () async {
      httpClientMock!.defineResponse(response: {}, statusCode: 200);
      final response = await database.delete('any', 'any');
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => Notification('', '')).message, 'Item deletado com sucesso');
      expect(response.getOrElse(() => Notification('', '')).key, 'ParseDatabaseService.delete');
    });
    test('should return Left(Notification) when error to delete object', () async {
      final expectedResponse = {"code": 101, "error": "Object not found."};
      httpClientMock!.defineResponse(response: expectedResponse, statusCode: 404);
      final response = await database.delete('any', 'any');
      expect(response.isLeft(), isTrue);
      response.fold((not) => expect(not.message, 'Usuário/senha inválido'), (map) => false);
    });
  });

  group('Test ParseDatabaseService.getAll(table)', () {
    test('should return Right(List) when success getAll response', () async {
      httpClientMock!.defineResponse(response: kGetAllWalletsResponseMap, statusCode: 200);
      final response = await database.getAll("any");
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => []).first, isInstanceOf<ParseObject>());
    });
    test('should return Left(Notification) when invalid getAll response', () async {
      httpClientMock!.defineResponse(response: {"code": 102}, statusCode: 102);
      final response = await database.getAll("any");
      expect(response.isLeft(), isTrue);
      response.fold((notification) => expect(notification.message, 'Consulta inválida (InvalidQuery)'), (map) => false);
    });
  });

  group('Test ParseDatabaseService.filterByRelation', () {
    test('should return Right(List) when success filterByRelation response', () async {
      httpClientMock!.defineResponse(response: kGetAllWalletsResponseMap, statusCode: 200);
      final response = await database.filterByRelation('Wallet', ['category'], ['123456']);
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => []).first, isInstanceOf<ParseObject>());
    });
    test('should return Left(Notification) when filterByRelation response', () async {
      httpClientMock!.defineResponse(response: {"code": 102}, statusCode: 102);
      final response = await database.filterByRelation('Wallet', ['user'], ['123456']);
      expect(response.isLeft(), isTrue);
      response.fold((notification) => expect(notification.message, 'Consulta inválida (InvalidQuery)'), (map) => false);
    });
  });

  group('Test ParseDatabaseService.filterByProperties', () {
    test('should return Right(List) when success filterByProperties response', () async {
      httpClientMock!.defineResponse(response: kGetAllWalletsResponseMap, statusCode: 200);
      final response = await database.filterByProperties('Wallet', ['objectId'], ['123456']);
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => []).first, isInstanceOf<ParseObject>());
    });
    test('should return Left(Notification) when filterByProperties response', () async {
      httpClientMock!.defineResponse(response: {"code": 102}, statusCode: 102);
      final response = await database.filterByProperties('Wallet', ['objectId'], ['123456']);
      expect(response.isLeft(), isTrue);
      response.fold((notification) => expect(notification.message, 'Consulta inválida (InvalidQuery)'), (map) => false);
    });
  });
}
