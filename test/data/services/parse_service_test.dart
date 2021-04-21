import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/services/parse_service.dart';
import 'package:king_investor/domain/agreements/database_agreement.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/parse_http_client_mock.dart';
import '../../static/statics.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');

  final expectedGetAllResponse = await rootBundle.loadString(kParseGetAllResponse);
  final expectedCreateResponse = await rootBundle.loadString(kParseCreateResponse);

  ParseHTTPClientMock httpClientMock = ParseHTTPClientMock();
  DatabaseAgreement parseService = ParseService(client: httpClientMock);

  test('should return Right(String) when success create response', () async {
    final httpResponse = ParseNetworkResponse(data: expectedCreateResponse, statusCode: 200);
    when(httpClientMock.post(any, data: '{}')).thenAnswer((_) async => Future.value(httpResponse));
    final response = await parseService.create("any", {});
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), 'UgXo8hOD4d');
  });

  test('should return Left(Notification) when error to create object', () async {
    final httpResponse = ParseNetworkResponse(data: '{"code": 103}', statusCode: 103);
    when(httpClientMock.post(any, data: '{}')).thenAnswer((_) async => Future.value(httpResponse));
    final response = await parseService.create("any", {});
    expect(response.isLeft(), isTrue);
    response.fold(
      (notification) => expect(notification.message, 'Nome da Classe inválida (InvalidClassName)'),
      (map) => false,
    );
  });

  test('should return Right(List) when success getAll response', () async {
    final httpResponse = ParseNetworkResponse(data: expectedGetAllResponse, statusCode: 200);
    when(httpClientMock.get(any)).thenAnswer((_) async => Future.value(httpResponse));
    final response = await parseService.getAll("any");
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null).first, isInstanceOf<ParseObject>());
  });

  test('should return Left(Notification) when invalid getAll response', () async {
    final httpResponse = ParseNetworkResponse(data: '{"code": 102}', statusCode: 102);
    when(httpClientMock.get(any)).thenAnswer((_) async => Future.value(httpResponse));
    final response = await parseService.getAll("any");
    expect(response.isLeft(), isTrue);
    response.fold((notification) => expect(notification.message, 'Consulta inválida (InvalidQuery)'), (map) => false);
  });
}
