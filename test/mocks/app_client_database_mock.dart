import 'dart:convert';

import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:uuid/uuid.dart';

import '../static/assets_response.dart';
import '../static/categories_response.dart';
import '../static/category_scores_response.dart';
import '../static/companies_response.dart';
import '../static/wallets_response.dart';

/* Classe para definir os retornos esperados do servidor de database;
// Útil durante o desenvolvimento, para evitar excessso de requisições; */

class AppClientDatabaseMock extends Mock implements ParseClient {
  @override
  Future<ParseNetworkResponse> post(String path, {String data, ParseNetworkOptions options}) async {
    await Future.delayed(Duration(milliseconds: 200));
    String uuid = Uuid().v1().replaceAll('-', '').substring(0, 10);
    String date = DateTime.now().toIso8601String().substring(0, 23) + 'Z';
    final response = '{"objectId": "$uuid", "createdAt": "$date"}';
    return ParseNetworkResponse(data: response, statusCode: 201);
  }

  @override
  Future<ParseNetworkResponse> get(
    String path, {
    ParseNetworkOptions options,
    ProgressCallback onReceiveProgress,
  }) async {
    String responseData = '';
    if (path.contains('classes/' + kWalletTable))
      responseData = json.encode(kGetAllWalletsResponseMap);
    else if (path.contains('classes/' + kCategoryTable))
      responseData = json.encode(kGetAllCategoriesResponseMap);
    else if (path.contains('classes/' + kCompanyTable))
      responseData = json.encode(kGetAllCompaniesResponseMap);
    else if (path.contains('classes/' + kAssetTable))
      responseData = json.encode(kGetAllAssetsResponseMap);
    else if (path.contains('classes/' + kCategoryScoreTable))
      responseData = json.encode(kGetAllCategoryScoresResponseMap);

    if (responseData.isEmpty) return ParseNetworkResponse(data: '{}', statusCode: 400);
    return ParseNetworkResponse(data: responseData, statusCode: 200);
  }

  @override
  Future<ParseNetworkResponse> put(String path, {String data, ParseNetworkOptions options}) async {
    await Future.delayed(Duration(milliseconds: 200));
    String date = DateTime.now().toIso8601String() + 'Z';
    return ParseNetworkResponse(data: '{"updatedAt": "$date"}', statusCode: 200);
  }

  @override
  Future<ParseNetworkResponse> delete(String path, {ParseNetworkOptions options}) async {
    await Future.delayed(Duration(milliseconds: 200));
    return ParseNetworkResponse(data: '{}', statusCode: 200);
  }
}
