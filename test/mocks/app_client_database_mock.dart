import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:uuid/uuid.dart';

/* Classe para definir os retornos esperados do servidor de database;
// Útil durante o desenvolvimento, para evitar excessso de requisições; */

class AppClientAuthenticationMock extends Mock implements ParseClient {
  @override
  Future<ParseNetworkResponse> post(String path, {String data, ParseNetworkOptions options}) async {
    await Future.delayed(Duration(milliseconds: 200));
    String uuid = Uuid().v1().replaceAll('-', '').substring(0, 10);
    String date = DateTime.now().toIso8601String() + 'Z';
    final response = {"objectId": uuid, "createdAt": date};
    return ParseNetworkResponse(data: '$response', statusCode: 200);
  }

  @override
  Future<ParseNetworkResponse> get(
    String path, {
    ParseNetworkOptions options,
    ProgressCallback onReceiveProgress,
  }) async {
    String responseData = '';
    if (path.contains(kWalletTable))
      responseData = kGetAllWallets;
    else if (path.contains(kCategoryTable))
      responseData = kGetAllCategory;
    else if (path.contains(kCompanyTable))
      responseData = kGetAllCompany;
    else if (path.contains(kAssetTable))
      responseData = kGetAllAsset;
    else if (path.contains(kCategoryScoreTable)) responseData = kGetAllCategoryScore;

    if (responseData.isEmpty) return ParseNetworkResponse(data: '{}', statusCode: 400);
    return ParseNetworkResponse(data: responseData, statusCode: 200);
  }

  @override
  Future<ParseNetworkResponse> put(String path, {String data, ParseNetworkOptions options}) async {
    await Future.delayed(Duration(milliseconds: 200));
    String date = DateTime.now().toIso8601String() + 'Z';
    return ParseNetworkResponse(data: '{"updatedAt": $date}', statusCode: 200);
  }

  @override
  Future<ParseNetworkResponse> delete(String path, {ParseNetworkOptions options}) async {
    await Future.delayed(Duration(milliseconds: 200));
    return ParseNetworkResponse(data: '{}', statusCode: 200);
  }
}

const kGetAllWallets =
    '{"results":[{"objectId":"7jgnYX0BBi","name":"Principal","isMainWallet":true,"client":{"__type":"Pointer","className":"Client","objectId":"4BwpMWdCnm"},"createdAt":"2021-04-19T00:12:32.750Z","updatedAt":"2021-04-19T00:12:32.750Z"},{"objectId":"sI92wSvh9l","name":"Adicional","isMainWallet":false,"client":{"__type":"Pointer","className":"Client","objectId":"4BwpMWdCnm"},"createdAt":"2021-04-19T00:12:32.750Z","updatedAt":"2021-04-19T00:12:32.750Z"}]}';

const kGetAllCategory =
    '{"results":[{"objectId":"zJxVP17mTi","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"Ação","order":0},{"objectId":"gd8djpy4lk","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"Fii","order":1},{"objectId":"sDX2g0D7WP","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"Fundo de \u00cdndice","order":2},{"objectId":"E6Bzg4w3lX","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"Stock","order":3},{"objectId":"rvwdRmdpP4","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"REIT","order":4},{"objectId":"uEMtszTO2V","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"ETF","order":5},{"objectId":"YNs2Ehoady","createdAt":"2018-10-31T14:16:13.616Z","updatedAt":"2018-11-07T12:12:20.758Z","name":"Outro","order":6}]}';

const kGetAllCompany =
    '{"results":[{"objectId":"Nentyg4662","symbol":"PSSA3","ticker":"pssa3:bz","currency":"BRL","region":"AMERICAS","name":"Porto Seguro SA","securityType":"Common Stock","exchange":"B3","country":"Brasil","createdAt":"2021-04-21T20:17:34.695Z","updatedAt":"2021-04-22T01:30:31.708Z","ACL":{"*":{"read":true}}},{"objectId":"KsLI2Ht7nc","symbol":"XPML11","ticker":"xpml11:bz","currency":"BRL","region":"AMERICAS","name":"XP MALLS FDO INV IMOB FII","securityType":"Closed-End Fund","exchange":"B3","country":"Brasil","createdAt":"2021-04-21T20:17:34.695Z","updatedAt":"2021-04-22T01:30:31.708Z","ACL":{"*":{"read":true}}}]}';

const kGetAllAsset =
    '{"results": [ { "objectId": "INBOMkNhQE", "company": {"__type": "Pointer", "className": "Company", "objectId": "Nentyg4662"}, "category": { "__type": "Pointer", "className": "Category", "objectId": "7jgnYX0BBi", "createdAt": "2018-10-31T14:16:13.616Z", "updatedAt": "2018-11-07T12:12:20.758Z", "name": "Ação", "order": 0, }, "averagePrice": 45.04, "score": 10, "quantity": 6, "wallet": {"__type": "Pointer", "className": "Wallet", "objectId": "MlZIPMNohV"}, "createdAt": "2021-04-22T01:15:24.425Z", "updatedAt": "2021-04-22T01:15:24.425Z" }, { "objectId": "2Idh2KIgrc", "company": {"__type": "Pointer", "className": "Company", "objectId": "KsLI2Ht7nc"}, "category": { "__type": "Pointer", "className": "Category", "objectId": "gd8djpy4lk", "createdAt": "2018-10-31T14:16:13.616Z", "updatedAt": "2018-11-07T12:12:20.758Z", "name": "Fii", "order": 1, }, "averagePrice": 80.26, "score": 10, "quantity": 7, "wallet": {"__type": "Pointer", "className": "Wallet", "objectId": "MlZIPMNohV"}, "createdAt": "2021-04-22T01:15:24.425Z", "updatedAt": "2021-04-22T01:15:24.425Z" } ] }';

const kGetAllCategoryScore =
    '{"results": [ { "objectId": "cxgmtUYfM4", "score": 10, "category": { "__type": "Pointer", "className": "Category", "objectId": "gd8djpy4lk", "createdAt": "2018-10-31T14:16:13.616Z", "updatedAt": "2018-11-07T12:12:20.758Z", "name": "Fii", "order": 1, }, "wallet": {"__type": "Pointer", "className": "Wallet", "objectId": "7jgnYX0BBi"}, "createdAt": "2021-04-22T01:30:10.315Z", "updatedAt": "2021-04-22T01:30:10.315Z" }, { "objectId": "cxgmtUYfM4", "score": 10, "category": { "__type": "Pointer", "className": "Category", "objectId": "zJxVP17mTi", "createdAt": "2018-10-31T14:16:13.616Z", "updatedAt": "2018-11-07T12:12:20.758Z", "name": "Ação", "order": 0, }, "wallet": {"__type": "Pointer", "className": "Wallet", "objectId": "7jgnYX0BBi"}, "createdAt": "2021-04-22T01:30:10.315Z", "updatedAt": "2021-04-22T01:30:10.315Z" } ] }';
