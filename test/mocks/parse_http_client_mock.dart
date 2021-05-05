import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseHTTPClientMock extends Mock implements ParseClient {
  String _response;
  int _statusCode;

  defineResponse({Map<String, dynamic> response, int statusCode}) {
    _response = json.encode(response);
    _statusCode = statusCode;
  }

  @override
  Future<ParseNetworkResponse> post(String path, {String data, ParseNetworkOptions options}) async {
    return ParseNetworkResponse(data: _response, statusCode: _statusCode);
  }

  @override
  Future<ParseNetworkResponse> get(
    String path, {
    ParseNetworkOptions options,
    ProgressCallback onReceiveProgress,
  }) async {
    return ParseNetworkResponse(data: _response ?? '{}', statusCode: _statusCode ?? 400);
  }

  @override
  Future<ParseNetworkResponse> put(String path, {String data, ParseNetworkOptions options}) async {
    return ParseNetworkResponse(data: _response ?? '{}', statusCode: _statusCode ?? 400);
  }

  @override
  Future<ParseNetworkResponse> delete(String path, {ParseNetworkOptions options}) async {
    return ParseNetworkResponse(data: _response ?? '{}', statusCode: _statusCode ?? 400);
  }
}
