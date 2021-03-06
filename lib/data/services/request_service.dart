import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class RequestService implements RequestAgreement {
  Dio _dio;

  RequestService({Dio dio}) {
    _dio = dio ?? Dio();
  }

  @override
  void configureRequests({
    int conectTimeoutMiliseconds: 5000,
    int sendTimeoutMiliseconds: 5000,
    int receiveTimeoutMiliseconds: 10000,
    Map<String, dynamic> headers,
    String baseUrl: '',
  }) {
    _dio.options = BaseOptions(
      connectTimeout: conectTimeoutMiliseconds,
      sendTimeout: sendTimeoutMiliseconds,
      receiveTimeout: receiveTimeoutMiliseconds,
      headers: headers,
      baseUrl: baseUrl,
    );
  }

  @override
  Future<Either<Notification, Map>> request(String url) async {
    try {
      final Response response = await _dio.get(url);
      print('*** REQUEST *** $url');
      return _validateResponse(response);
    } catch (error) {
      return Left(_onError(error));
    }
  }

  Either<Notification, Map> _validateResponse(Response response) {
    if (response == null || response.statusCode != 200) {
      return Left(Notification('RequestService.invalidResponse', 'O servidor retornou uma resposta inválida.'));
    } else {
      return Right(Map.from(response.data));
    }
  }

  Notification _onError(error) {
    if (error.runtimeType == TimeoutException) {
      return Notification('RequestService.timeout', 'O servidor demorou muito para responder a solicitação.');
    } else if (error.runtimeType == DioError) {
      return _dioError(error);
    } else {
      return Notification('RequestService.unkown', 'Erro desconhecido');
    }
  }

  Notification _dioError(error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
        return Notification('RequestService.networkError', 'Não foi possível conectar-se a rede.');
      case DioErrorType.receiveTimeout:
        return Notification('RequestService.receiveTimeout', 'O Servidor demorou para responder.');
      case DioErrorType.response:
        return Notification('RequestService.invalidResponse', 'O servidor retornou uma resposta inválida.');
      default:
        return Notification('RequestService.unkown', 'Erro desconhecido');
    }
  }
}
