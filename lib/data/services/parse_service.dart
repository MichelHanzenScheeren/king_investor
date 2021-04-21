import 'package:dartz/dartz.dart';
import 'package:king_investor/data/utils/parse_exception.dart';
import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:king_investor/domain/agreements/parse_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:king_investor/shared/extensions/string_extension.dart';

const pointerIndicator = 'foreignkey';

class ParseService implements ParseAgreement {
  ParseClient _client;

  ParseService({ParseClient client}) {
    _client = client ?? ParseHTTPClient();
  }

  @override
  Future<Either<Notification, String>> create(String table, Map dynamicMap) async {
    try {
      final parseObject = ParseObject(table, client: _client);
      _registerDataOfCreateObject(parseObject, dynamicMap);
      final response = await parseObject.create(allowCustomObjectId: true);
      if (response.success) return Right(parseObject.objectId);
      return Left(Notification('ParseService.create', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseService.create', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> edit(String table, Map map) async {
    try {
      final parseObject = ParseObject(table, client: _client);
      map.keys.forEach((key) => parseObject.set(key, map[key]));
      final response = await parseObject.update();
      if (response.success) return Right(Notification('ParseService.edit', 'Item editado com sucesso'));
      return Left(Notification('ParseService.edit', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseService.edit', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> delete(String table, String objectId) async {
    try {
      final parseObject = ParseObject(table, client: _client)..objectId = objectId;
      final response = await parseObject.delete();
      if (response.success) return Right(Notification('ParseService.delete', 'Item deletado com sucesso'));
      return Left(Notification('ParseService.delete', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseService.delete', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, List>> getAll(String table, List<String> objectsToInclude) async {
    try {
      QueryBuilder myQuery = QueryBuilder<ParseObject>(ParseObject(table, client: _client));
      myQuery.includeObject(objectsToInclude);
      final response = await myQuery.query();
      if (response.success) return Right(response.results);
      return Left(Notification('ParseService.getAll', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseService.getAll', erro.toString()));
    }
  }

  void _registerDataOfCreateObject(ParseObject parseObject, Map dynamicMap) {
    Map map = Map<String, dynamic>.from(dynamicMap);
    map.keys.forEach((key) {
      if (key.toLowerCase().contains(pointerIndicator)) {
        String newKey = key.toLowerCase().replace(pointerIndicator, '');
        if (newKey.capitalize() == kUserTable)
          parseObject.set<ParseUser>(newKey, ParseUser('', '', '')..objectId = map[key]);
        else
          parseObject.set<ParseObject>(newKey, ParseObject(newKey.capitalize())..objectId = map[key]);
      } else {
        parseObject.set(key, map[key]);
      }
    });
  }
}
