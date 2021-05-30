import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../static/authentication_response.dart';

/* Classe para definir os retornos esperados do servidor de autenticação;
// Útil durante o desenvolvimento, para evitar excessso de requisições; */

class AppClientAuthenticationMock extends Mock implements ParseClient {
  @override
  Future<ParseNetworkResponse> post(String path, {String? data, ParseNetworkOptions? options}) async {
    if (path.contains('logout')) return Future.value(ParseNetworkResponse(data: '{}', statusCode: 200));
    return ParseNetworkResponse(data: kSignUpSucessResponseJSON, statusCode: 200);
  }

  @override
  Future<ParseNetworkResponse> get(
    String path, {
    ParseNetworkOptions? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    final responseData = kLoginSucessResponseJSON;
    return ParseNetworkResponse(data: responseData, statusCode: 200);
  }
}
