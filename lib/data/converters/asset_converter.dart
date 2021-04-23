import 'package:king_investor/data/converters/category_converter.dart';
import 'package:king_investor/data/converters/company_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';

class AssetConverter {
  Asset fromMapToModel(map) {
    return Asset(
      map[kObjectId],
      map[kCreatedAt],
      CompanyConverter().fromMapToModel(map[kCompany]),
      CategoryConverter().fromMapToModel(map[kCategory]),
      Amount(map[kAveragePrice]),
      Score(map[kScore]),
      Quantity(map[kQuantity]),
      map[kWallet][kObjectId],
    );
  }

  Map fromModelToMap(Asset asset) {
    return {
      kObjectId: asset.objectId,
      kCreatedAt: asset.createdAt,
      kCompanyForeignKey: asset.company.objectId,
      kCategoryForeignKey: asset.category.objectId,
      kAveragePrice: asset.averagePrice,
      kScore: asset.score,
      kQuantity: asset.quantity,
      kWalletForeignKey: asset.walletForeignKey,
    };
  }
}
