import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/services/request_service.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:mockito/mockito.dart';
import '../../static/search_response.dart';

class HttpClientMock extends Mock implements HttpClientAdapter {}

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  final responseData = kSearchResponseMap;

  Dio dio;
  HttpClientMock httpClientMock;
  RequestAgreement requestService;
  setUp(() {
    dio = Dio();
    httpClientMock = HttpClientMock();
    dio.httpClientAdapter = httpClientMock;
    requestService = RequestService(dio);
  });

  test('should return Right(map) when success request', () async {
    final httpResponse = ResponseBody.fromString(jsonEncode(responseData), 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType]
    });
    when(httpClientMock.fetch(any, any, any)).thenAnswer((_) async => httpResponse);
    final response = await requestService.request("/any url");

    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), responseData);
  });

  test('should return Left(Notification) when failed request', () async {
    final httpResponse = ResponseBody.fromString(jsonEncode({}), 400);
    when(httpClientMock.fetch(any, any, any)).thenAnswer((_) async => httpResponse);
    final response = await requestService.request("/any url");

    expect(response.isLeft(), isTrue);
    response.fold((notification) => expect(notification, isInstanceOf<Notification>()), (map) => false);
  });
}
