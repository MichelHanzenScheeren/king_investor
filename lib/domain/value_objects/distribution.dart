import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

const String _kIdentifier = 'identifier';
const String _kTotalValue = 'totalValue';
const String _kQuantity = 'quantity';
const String _kPrice = 'price';

class Distribution extends ValueObject {
  List<DistributionResultItem> _items = <DistributionResultItem>[];

  DistributionResult fromCategories(List<Category> categories, List<Asset> assets, List<Price> prices) {
    Map<String, Map<String, dynamic>> categoriesTotal = <String, Map<String, dynamic>>{};
    double totalValue = 0;
    assets.forEach((asset) {
      final Price price = _getPrice(asset, prices);
      totalValue += (asset.quantity.value * price.lastPrice.value);
      if (!categoriesTotal.containsKey(asset.category.objectId))
        categoriesTotal[asset.category.objectId] = {_kTotalValue: 0.0, _kQuantity: 0, _kPrice: 0.0};
      final auxMap = categoriesTotal[asset.category.objectId]!;
      auxMap[_kIdentifier] = asset.category.objectId;
      auxMap[_kTotalValue] += (asset.quantity.value * price.lastPrice.value);
      auxMap[_kQuantity] += asset.quantity.value;
      auxMap[_kPrice] = (auxMap[_kPrice] + price.lastPrice.value) / 2;
    });
    categoriesTotal.removeWhere((key, value) => !categories.any((element) => element.objectId == key));
    categoriesTotal.forEach((key, current) {
      double value = current[_kTotalValue] * 100 / totalValue;
      String title = categories.firstWhere((element) => element.objectId == key).name;
      _items.add(DistributionResultItem(
        current[_kIdentifier],
        title,
        Amount(value),
        Amount(current[_kPrice]),
        Amount(current[_kTotalValue]),
        Quantity(current[_kQuantity]),
      ));
    });
    return DistributionResult(_items, Amount(totalValue));
  }

  DistributionResult fromAssets(List<Asset> assets, List<Price> prices) {
    Map<String, Map<String, dynamic>> assetsTotal = <String, Map<String, dynamic>>{};
    double totalValue = 0;
    assets.forEach((asset) {
      final Price price = _getPrice(asset, prices);
      totalValue += (asset.quantity.value * price.lastPrice.value);
      final auxMap = <String, dynamic>{};
      auxMap[_kIdentifier] = asset.company.ticker;
      auxMap[_kTotalValue] = (asset.quantity.value * price.lastPrice.value);
      auxMap[_kQuantity] = asset.quantity.value;
      auxMap[_kPrice] = price.lastPrice.value;
      assetsTotal[asset.company.symbol] = auxMap;
    });
    assetsTotal.forEach((key, current) {
      double? value = current[_kTotalValue] * 100 / totalValue;
      _items.add(DistributionResultItem(
        current[_kIdentifier],
        key,
        Amount(value),
        Amount(current[_kPrice]),
        Amount(current[_kTotalValue]),
        Quantity(current[_kQuantity]),
      ));
    });
    return DistributionResult(_items, Amount(totalValue));
  }

  Price _getPrice(Asset asset, List<Price> prices) {
    if (prices.any((element) => element.ticker == asset.company.ticker))
      return prices.firstWhere((element) => element.ticker == asset.company.ticker);
    return Price.fromDefaultValues(asset.company.ticker);
  }
}

class DistributionResult {
  List<DistributionResultItem> items;
  Amount totalValue;

  DistributionResult(this.items, this.totalValue);
}

class DistributionResultItem {
  final String identifier;
  final String title;
  final Amount percentageValue;
  final Amount price;
  final Amount totalValue;
  final Quantity quantity;

  DistributionResultItem(this.identifier, this.title, this.percentageValue, this.price, this.totalValue, this.quantity);
}
