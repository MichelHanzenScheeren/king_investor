import 'package:dartz/dartz.dart';
import 'package:king_investor/data/converters/asset_converter.dart';
import 'package:king_investor/data/converters/category_converter.dart';
import 'package:king_investor/data/converters/category_score_converter.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/data/converters/wallet_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/data/utils/parse_tables.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/models/model.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class DatabaseRepository implements DatabaseRepositoryAgreement {
  DatabaseServiceAgreement _database;

  DatabaseRepository(DatabaseServiceAgreement database) {
    _database = database;
  }

  @override
  Future<Either<Notification, String>> create(Object appObject) async {
    try {
      String tableName = getTableName(appObject.runtimeType);
      Map converted = convertToMap(appObject);
      return await _database.create(tableName, converted, ownerId: converted[kUserForeignKey]);
    } catch (erro) {
      return Left(_getError('create', erro));
    }
  }

  @override
  Future<Either<Notification, Notification>> update(Object appObject) async {
    try {
      String tableName = getTableName(appObject.runtimeType);
      Map converted = convertToMap(appObject);
      return await _database.update(tableName, converted);
    } catch (erro) {
      return Left(_getError('update', erro));
    }
  }

  @override
  Future<Either<Notification, Notification>> delete(Object appObject) async {
    try {
      String tableName = getTableName(appObject.runtimeType);
      Model model = appObject;
      return await _database.delete(tableName, model.objectId);
    } catch (erro) {
      return Left(_getError('delete', erro));
    }
  }

  @override
  Future<Either<Notification, List>> getAll(Type appClass) async {
    try {
      String tableName = getTableName(appClass);
      final response = await _database.getAll(tableName);
      return response.fold(
        (notification) => Left(notification),
        (list) => Right(_convertList(list, appClass)),
      );
    } catch (erro) {
      return Left(_getError('getAll', erro));
    }
  }

  String getTableName(Type type) {
    if (type == Asset) return kAssetTable;
    if (type == CategoryScore) return kCategoryScoreTable;
    if (type == Category) return kCategoryTable;
    if (type == Company) return kCompanyTable;
    if (type == Wallet) return kWalletTable;
    throw Exception('O tipo de dado não corresponde a nenhuma tabela válida do banco de dados');
  }

  Map convertToMap(Object object) {
    if (object is Asset) return AssetConverter().fromModelToMap(object);
    if (object is CategoryScore) return CategoryScoreConverter().fromModelToMap(object);
    if (object is Company) return CompanyConverter().fromModelToMap(object);
    if (object is Wallet) return WalletConverter().fromModelToMap(object);
    throw Exception('O tipo de dado não corresponde a uma conversão válida para o banco de dados');
  }

  List _convertList(List list, Type type) {
    int len = list.length;
    if (type == Asset) return List<Asset>.generate(len, (i) => AssetConverter().fromMapToModel(list[i]));
    if (type == Category) return List<Category>.generate(len, (i) => CategoryConverter().fromMapToModel(list[i]));
    if (type == Company) return List<Company>.generate(len, (i) => CompanyConverter().fromMapToModel(list[i]));
    if (type == Wallet) return List<Wallet>.generate(len, (i) => WalletConverter().fromMapToModel(list[i]));
    if (type == CategoryScore)
      return List<CategoryScore>.generate(len, (i) => CategoryScoreConverter().fromMapToModel(list[i]));
    throw Exception('O tipo de dado não corresponde a uma conversão válida de modelo');
  }

  Notification _getError(String key, dynamic error) {
    return Notification('DatabaseRepository.$key', error.toString());
  }
}