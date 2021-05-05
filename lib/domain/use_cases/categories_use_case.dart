import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class CategoriesUseCase {
  DatabaseRepositoryAgreement _database;
  AppData _appData;

  CategoriesUseCase(DatabaseRepositoryAgreement database, AppData appData) {
    _database = database;
    _appData = appData;
  }

  Future<Either<Notification, List<Category>>> getCategories() async {
    final categories = _appData.categories;
    if (categories.isNotEmpty) return Right(categories);

    final response = await _database.getAll(Category);
    return response.fold(
      (notification) => Left(notification),
      (categories) {
        _appData.registerCategories(categories);
        return Right(_appData.categories);
      },
    );
  }

  Future<Either<Notification, List<CategoryScore>>> getCategoryScores(String walletId) async {
    if (walletId == null || !_appData.containWallet(walletId))
      return Left(Notification('CategoryUseCase.getCategoryScores', 'Carteira não encontrada'));
    if (_appData.containCategoryScores(walletId)) return Right(_generateAllNecessaryScores(walletId));

    final response = await _database.filterByRelation(CategoryScore, [Wallet], [walletId], include: [Category]);
    return response.fold(
      (notification) => Left(notification),
      (list) {
        final List<CategoryScore> scores = List<CategoryScore>.from(list);
        _appData.registerCategoryScores(walletId, scores);
        return Right(_generateAllNecessaryScores(walletId));
      },
    );
  }

  Future<Either<Notification, Notification>> updateCategoryScores(String categoryScoreId, int newScoreValue) async {
    Score newScore = Score(newScoreValue);
    if (!newScore.isValid) return Left(Notification('CategoryUseCase.updateCategoryScores', 'Nota inválida'));
    CategoryScore current = _appData.getSpecificCategoryScore(categoryScoreId);
    if (current == null) return Left(Notification('CategoryUseCase.updateCategoryScores', 'Categoria inválida'));
    current.score.setValue(newScore.value);
    return await _database.update(current);
  }

  List<CategoryScore> _generateAllNecessaryScores(String walletId) {
    List<CategoryScore> scores = _appData.getCategoryScores(walletId);
    List<Category> categories = _appData.categories;
    categories.forEach((category) {
      if (!scores.any((score) => category.objectId == score.category.objectId)) {
        CategoryScore score = CategoryScore(null, null, Score(10), category, walletId);
        scores.add(score);
      }
    });
    return scores;
  }
}
