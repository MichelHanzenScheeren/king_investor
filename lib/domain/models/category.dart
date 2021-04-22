import 'package:king_investor/shared/models/model.dart';

class Category extends Model {
  final String name;
  final int order;

  Category(String objectId, DateTime createdAt, this.name, this.order) : super(objectId, createdAt);
}
