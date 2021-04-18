import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/score.dart';

const kObjectId = 'objectId';
const kCreatedAt = 'createdAt';
const kName = 'name';
const kOrder = 'order';
const kScore = 'score';

class CategoryConverter {
  Category fromMapToModel(Map map) {
    return Category(
      map[kObjectId],
      map[kCreatedAt],
      map[kName],
      map[kOrder],
      Score(map[kScore]),
    );
  }
}
