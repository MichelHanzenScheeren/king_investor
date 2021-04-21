import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/services/parse_service.dart';
import 'package:king_investor/domain/agreements/parse_agreement.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/parse_http_client_mock.dart';
import '../../static/statics.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');

  final expectedResponse = await rootBundle.loadString(kParseGetAllResponse);
  ParseHTTPClientMock httpClientMock = ParseHTTPClientMock();
  ParseAgreement parseService = ParseService(client: httpClientMock);

  test('should return Right(List) when success getAll response', () async {
    final httpResponse = ParseNetworkResponse(data: expectedResponse, statusCode: 200);
    when(httpClientMock.get(any)).thenAnswer((_) async => Future.value(httpResponse));
    final response = await parseService.getAll("any", []);
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null).first, isInstanceOf<ParseObject>());
  });

  test('should return Left(Notification) when invalid getAll response', () async {
    final httpResponse = ParseNetworkResponse(data: '{"code": 102}', statusCode: 102);
    when(httpClientMock.get(any)).thenAnswer((_) async => Future.value(httpResponse));
    final response = await parseService.getAll("any", []);
    expect(response.isLeft(), isTrue);
    response.fold((notification) => expect(notification.message, 'Consulta inválida (InvalidQuery)'), (map) => false);
  });
}
