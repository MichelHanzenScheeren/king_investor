import 'package:dartz/dartz.dart';
import 'package:king_investor/data/utils/parse_exception.dart';
import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:king_investor/shared/extensions/string_extension.dart';

const pointerIndicator = 'ForeignKey';

class ParseDatabaseService implements DatabaseServiceAgreement {
  ParseClient _client;

  ParseDatabaseService({ParseClient client}) {
    _client = client ?? ParseHTTPClient();
  }

  @override
  Future<Either<Notification, String>> create(String table, Map map, {String ownerId}) async {
    try {
      final parseObject = ParseObject(table, client: _client);
      _registerDataOfCreateObject(parseObject, map);
      final response = await parseObject.create(allowCustomObjectId: true);
      if (response.success) return Right(parseObject.objectId);
      return Left(Notification('ParseDatabaseService.create', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.create', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> update(String table, Map map) async {
    try {
      final parseObject = ParseObject(table, client: _client);
      _registerDataOfCreateObject(parseObject, map);
      final response = await parseObject.update();
      if (response.success) return Right(Notification('ParseDatabaseService.edit', 'Item editado com sucesso'));
      return Left(Notification('ParseDatabaseService.edit', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.edit', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, Notification>> delete(String table, String objectId) async {
    try {
      final parseObject = ParseObject(table, client: _client)..objectId = objectId;
      final response = await parseObject.delete();
      if (response.success) return Right(Notification('ParseDatabaseService.delete', 'Item deletado com sucesso'));
      return Left(Notification('ParseDatabaseService.delete', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.delete', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, List>> getAll(String table, {List<String> objectsToInclude}) async {
    try {
      QueryBuilder myQuery = QueryBuilder<ParseObject>(ParseObject(table, client: _client));
      myQuery.includeObject(objectsToInclude ?? <String>[]);
      final response = await myQuery.query();
      if (response.success) return Right(response.results);
      return Left(Notification('ParseDatabaseService.getAll', ParseException.getDescription(response.statusCode)));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.getAll', erro.toString()));
    }
  }

  void _registerDataOfCreateObject(ParseObject parseObject, Map dynamicMap) {
    Map<String, dynamic> map = Map<String, dynamic>.from(dynamicMap);
    map.keys.forEach((key) {
      if (key.contains(pointerIndicator)) {
        String newKey = key.replaceAll(pointerIndicator, '');
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
