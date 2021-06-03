import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class DayPerformance extends ValueObject {
  late List<Price> _prices;
  late List<Asset> _assets;
  late List<Category> _categories;
  final List<DayPerformanceResult> _items = <DayPerformanceResult>[];

  DayPerformance(List<Price> prices, List<Asset> assets, List<Category> categories) {
    _prices = List.from(prices);
    _assets = List.from(assets);
    _categories = List.from(categories);
  }

  List<DayPerformanceResult> measurePerformance() {
    _removeInvalidAsets();
    _measurePerformance('Geral', _assets);
    _categories.forEach((category) {
      final filtred = _assets.where((asset) => asset.category.objectId == category.objectId).toList();
      _measurePerformance(category.name, filtred);
    });
    return _items;
  }

  void _removeInvalidAsets() {
    _assets.removeWhere((asset) => !_prices.any((price) => price.ticker == asset.company.ticker));
    _assets.removeWhere((asset) {
      final Price price = _prices.firstWhere((price) => price.ticker == asset.company.ticker);
      return price.lastPrice.value == 0;
    });
  }

  void _measurePerformance(String identifier, List<Asset> assets) {
    double totalValue = 0.0;
    double previousValue = 0.0;
    assets.forEach((asset) {
      final Price price = _prices.firstWhere((price) => price.ticker == asset.company.ticker);
      totalValue += (price.lastPrice.value * asset.quantity.value);
      previousValue += (price.lastPrice.value * asset.quantity.value) * 100 / (price.variation.value + 100);
    });
    double variation = 100 - (previousValue * 100 / totalValue);
    final item = DayPerformanceResult(identifier, Amount(variation), Amount(totalValue - previousValue));
    _items.add(item);
  }
}

class DayPerformanceResult {
  String identifier;
  Amount variation;
  Amount earnings;

  DayPerformanceResult(this.identifier, this.variation, this.earnings);
}
