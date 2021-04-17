import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/services/request_service.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:mockito/mockito.dart';

class DioMock extends Mock implements HttpClientAdapter {}

const searchJsonPath = 'assets/test/search_response.json';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  final responseData = Map.from(json.decode(await rootBundle.loadString(searchJsonPath)));

  Dio dio;
  DioMock dioMock;
  RequestAgreement requestService;
  setUp(() {
    dio = Dio();
    dioMock = DioMock();
    dio.httpClientAdapter = dioMock;
    requestService = RequestService(dio);
  });

  test('should return Right(map) when success request', () async {
    final httpResponse = ResponseBody.fromString(jsonEncode(responseData), 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType]
    });
    when(dioMock.fetch(any, any, any)).thenAnswer((_) async => httpResponse);
    final response = await requestService.request("/any url");

    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), responseData);
  });

  test('should return Left(Notification) when failed request', () async {
    final httpResponse = ResponseBody.fromString(jsonEncode({}), 400);
    when(dioMock.fetch(any, any, any)).thenAnswer((_) async => httpResponse);
    final response = await requestService.request("/any url");

    expect(response.isLeft(), isTrue);
    response.fold((notification) => expect(notification, isInstanceOf<Notification>()), (map) => false);
  });
}
