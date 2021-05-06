import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/database_repository.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../../mocks/app_client_database_mock.dart';

main() {
  AppData appData;
  CategoriesUseCase categoriesUseCase;
  Wallet wallet1;

  setUpAll(() async {
    await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    AppClientDatabaseMock client = AppClientDatabaseMock();
    DatabaseServiceAgreement databaseService = ParseDatabaseService(client: client);
    DatabaseRepositoryAgreement database = DatabaseRepository(databaseService);
    appData = AppData();
    User user = User(null, null, Name('Michel', 'Scheere'), Email('michel@gmail.com'));
    wallet1 = Wallet.createMainWallet(user.objectId);
    appData.registerUser(user);
    appData.registerWallets([wallet1]);
    categoriesUseCase = CategoriesUseCase(database, appData);
  });

  group('Tests about CategoriesUseCase.getCategories', () {
    test('should Return Right(List<Categories>)', () async {
      final response = await categoriesUseCase.getCategories();
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => null)?.length, 7);
    });
    test('expect appData.categories contains getted categories)', () async {
      expect(appData.categories.length, 7);
    });
  });

  group('Tests about CategoriesUseCase.getCategoryScores', () {
    test('should Return left when send null to walletId parameter)', () async {
      final response = await categoriesUseCase.getCategoryScores(null);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l?.message, (r) => null), 'Carteira não encontrada');
    });
    test('should Return left when send invalid value to walletId parameter)', () async {
      final response = await categoriesUseCase.getCategoryScores('123789');
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l?.message, (r) => null), 'Carteira não encontrada');
    });
    test('should Return Right(List) when correct request', () async {
      final response = await categoriesUseCase.getCategoryScores(wallet1.objectId);
      expect(response.isRight(), isTrue);
      expect(response.getOrElse(() => null)?.length, 7);
    });
    test('expect appData.categoryScores[walleId] contains getted categoriesScores)', () async {
      final scoresOfWallet1 = appData.getCategoryScores(wallet1.objectId);
      expect(scoresOfWallet1, isInstanceOf<List<CategoryScore>>());
      expect(scoresOfWallet1.length, 2);
    });
  });

  group('Tests about CategoriesUseCase.updateCategoryScores', () {
    test('should Return left when send null to catScore parameter', () async {
      final response = await categoriesUseCase.updateCategoryScores(null);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l?.message, (r) => null), 'Nota de categoria inválida');
    });
    test('should Return left when send invalid categoryScore', () async {
      final score = CategoryScore(null, null, Score(null), Category(null, null, 'A', 9), 'AB');
      final response = await categoriesUseCase.updateCategoryScores(score);
      expect(response.isLeft(), isTrue);
    });
    test('should Return left when send wallet that doesnt exists', () async {
      final score = CategoryScore(null, null, Score(5), Category(null, null, 'A', 9), 'AB');
      final response = await categoriesUseCase.updateCategoryScores(score);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l?.message, (r) => null), 'Carteira não encontrada');
    });
    test('should Return left when send category that doesnt exists', () async {
      final score = CategoryScore(null, null, Score(5), Category(null, null, 'A', 9), wallet1.objectId);
      final response = await categoriesUseCase.updateCategoryScores(score);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l?.message, (r) => null), 'Categoria não encontrada');
    });
    test('should Return left when send exists categoryScore with invalid id', () async {
      final score = CategoryScore(null, null, Score(5), appData.categories.first, wallet1.objectId);
      final response = await categoriesUseCase.updateCategoryScores(score);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l?.message, (r) => null), 'Tentativa de edição inválida');
    });
    test('should Return Right when valid categoryScore that already exist', () async {
      final score = CategoryScore('cxgmtUYfM4', null, Score(5), appData.categories.first, wallet1.objectId);
      final response = await categoriesUseCase.updateCategoryScores(score);
      expect(response.isRight(), isTrue);
      final newScore = appData.getCategoryScores(wallet1.objectId).first;
      expect(newScore.score.value, 5);
      expect(newScore.objectId, 'cxgmtUYfM4');
      expect(newScore.category.objectId, appData.categories.first.objectId);
    });

    test('should Return Right when valid categoryScore that non exists', () async {
      final score = CategoryScore(null, null, Score(8), appData.categories[4], wallet1.objectId);
      final response = await categoriesUseCase.updateCategoryScores(score);
      expect(response.isRight(), isTrue);
      final newScore = appData.getCategoryScores(wallet1.objectId).last;
      expect(newScore.score.value, 8);
      expect(newScore.category.objectId, appData.categories[4].objectId);
    });
  });
}
