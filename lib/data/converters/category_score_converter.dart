import 'package:king_investor/data/converters/category_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/value_objects/score.dart';

class CategoryScoreConverter {
  CategoryScore fromMapToModel(map) {
    return CategoryScore(
      map[kObjectId],
      map[kCreatedAt],
      Score(map[kScore]),
      CategoryConverter().fromMapToModel(map[kCategory]),
      map[kWallet][kObjectId],
    );
  }

  Map fromModelToMap(CategoryScore categoryScore) {
    return {
      kObjectId: categoryScore.objectId,
      kCreatedAt: categoryScore.createdAt,
      kScore: categoryScore.score.value,
      kCategoryForeignKey: categoryScore.category.objectId,
      kWalletForeignKey: categoryScore.walletForeignKey,
    };
  }
}
