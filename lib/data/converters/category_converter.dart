import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/category.dart';

class CategoryConverter {
  Category fromMapToModel(map) {
    return Category(
      map[kObjectId],
      map[kCreatedAt],
      map[kName],
      map[kOrder],
    );
  }
}
