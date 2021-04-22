import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/shared/models/model.dart';

class CategoryScore extends Model {
  final Score score; // "nota" ou "peso" da categoria na carteira
  final Category category;
  final String walletForeignKey;

  CategoryScore(
    String objectId,
    DateTime createdAt,
    this.score,
    this.category,
    this.walletForeignKey,
  ) : super(objectId, createdAt);
}
