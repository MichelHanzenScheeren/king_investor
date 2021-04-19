import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/score.dart';

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
