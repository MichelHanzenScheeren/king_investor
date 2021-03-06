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
      Amount((map[kAveragePrice] ?? 0.0) + 0.0),
      Score(map[kScore]),
      Quantity(map[kQuantity]),
      map[kWallet][kObjectId],
      sales: Amount((map[kSales] ?? 0.0) + 0.0),
      incomes: Amount((map[kIncomes] ?? 0.0) + 0.0),
    );
  }

  Map fromModelToMap(Asset asset) {
    return {
      kObjectId: asset.objectId,
      kCreatedAt: asset.createdAt,
      kCompanyForeignKey: asset.company.objectId,
      kCategoryForeignKey: asset.category.objectId,
      kAveragePrice: asset.averagePrice.value,
      kScore: asset.score.value,
      kQuantity: asset.quantity.value,
      kWalletForeignKey: asset.walletForeignKey,
      kSales: asset.sales.value,
      kIncomes: asset.incomes.value,
    };
  }
}
