import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/shared/models/model.dart';

class Category extends Model {
  final String name;
  final int order;
  final Score score; // "nota" ou "peso" da categoria na carteira

  Category(String objectId, DateTime createdAt, this.name, this.order, this.score) : super(objectId, createdAt) {
    addNotifications(score);
  }
}
