import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/database_repository.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/notifications/notification.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../../mocks/app_client_database_mock.dart';

main() {
  AppClientDatabaseMock databaseClientMock;
  DatabaseServiceAgreement databaseService;
  late DatabaseRepositoryAgreement repository;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    databaseClientMock = AppClientDatabaseMock();
    databaseService = ParseDatabaseService(client: databaseClientMock);
    repository = DatabaseRepository(databaseService);
  });

  test('Should return a valid table name when use getTableName()', () {
    expect(DatabaseRepository(ParseDatabaseService()).getTableName(Wallet), 'Wallet');
  });

  test('Should return a valid table name when use getTableName()', () {
    expect(DatabaseRepository(ParseDatabaseService()).getTableName(User), 'User');
  });

  test('Should return Right(Notification) when save in database', () async {
    final response = await repository.create(Wallet.createMainWallet('1234'));
    expect(response.getOrElse(() => Notification('', '')).message, 'Item salvo com sucesso');
  });

  test('Should return correct Notification when update', () async {
    final response = await repository.update(Wallet.createMainWallet('1234'));
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r.message, 'Item editado com sucesso'));
  });

  test('Should return correct Notification when delete', () async {
    final response = await repository.delete(Wallet.createMainWallet('1234'));
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r.message, 'Item deletado com sucesso'));
  });

  test('Should return correct list of wallets when use getAll()', () async {
    final response = await repository.getAll(Wallet);
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r, isInstanceOf<List>()));
  });

  test('Should return correct list of wallets when use getAll() and include objects', () async {
    final response = await repository.getAll(Wallet, include: [Category]);
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r, isInstanceOf<List>()));
  });

  test('Should return Left(Notification) when use getAll() and include invalid object', () async {
    final response = await repository.getAll(Wallet, include: [User]);
    response.fold(
      (l) => expect(l.message.contains('O tipo de dado não corresponde a uma inclusão válida de uma tabela'), isTrue),
      (r) => expect(isTrue, isFalse),
    );
  });

  test('Should return correct list of wallets when use filterByRelation()', () async {
    final response = await repository.filterByRelation(Wallet, [User, Category], ['1234', '5678']);
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r, isInstanceOf<List>()));
  });

  test('Should return correct list of wallets when use filterByRelation()', () async {
    final response = await repository.filterByRelation(Wallet, [User, Category], ['1234', '5678']);
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r, isInstanceOf<List>()));
  });

  test('Should return correct list of wallets when use filterByProperties()', () async {
    final response = await repository.filterByProperties(Wallet, ['objectId'], ['12345']);
    response.fold((l) => expect(isTrue, isFalse), (r) => expect(r, isInstanceOf<List>()));
  });
}
