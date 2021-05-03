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
      return Left(_getError('create', response.statusCode));
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
      return Left(_getError('update', response.statusCode));
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
      return Left(_getError('delete', response.statusCode));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.delete', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, List>> getAll(String table, {List<String> objectsToInclude: const <String>[]}) async {
    try {
      QueryBuilder myQuery = QueryBuilder<ParseObject>(ParseObject(table, client: _client));
      myQuery.includeObject(objectsToInclude);
      final response = await myQuery.query();
      if (response.success) return Right(response.results);
      return Left(_getError('getAll', response.statusCode));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.getAll', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, List>> filterByRelation(
    String table,
    List<String> relations,
    List<String> keys, {
    List<String> objectsToInclude: const <String>[],
  }) async {
    try {
      QueryBuilder myQuery = QueryBuilder<ParseObject>(ParseObject(table, client: _client));
      for (int i = 0; i < relations.length; i++) {
        dynamic parse;
        if (relations[i] == 'User')
          parse = ParseUser('', '', '')..objectId = keys[i];
        else
          parse = ParseObject(relations[i])..objectId = keys[i];
        myQuery.whereEqualTo(relations[i].toLowerCase(), parse);
      }
      myQuery.includeObject(objectsToInclude);
      final response = await myQuery.query();
      if (response.success) return Right(response.results);
      return Left(_getError('filterByRelation', response.statusCode));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.filterByRelation', erro.toString()));
    }
  }

  @override
  Future<Either<Notification, List>> filterByProperties(
    String table,
    List<String> properties,
    List<String> values, {
    List<String> objectsToInclude: const <String>[],
  }) async {
    try {
      QueryBuilder myQuery = QueryBuilder<ParseObject>(ParseObject(table, client: _client));
      for (int i = 0; i < properties.length; i++) {
        myQuery.whereEqualTo(properties[i], values[i]);
      }
      myQuery.includeObject(objectsToInclude);
      final response = await myQuery.query();
      if (response.success) return Right(response.results);
      return Left(_getError('filterByProperties', response.statusCode));
    } catch (erro) {
      return Left(Notification('ParseDatabaseService.filterByProperties', erro.toString()));
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

  Notification _getError(String function, int number) {
    return Notification('ParseDatabaseService.$function', ParseException.getDescription(number));
  }
}
