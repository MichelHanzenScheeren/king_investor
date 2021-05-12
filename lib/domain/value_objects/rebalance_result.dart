import 'dart:collection';

import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/rebalance.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class RebalanceResult extends ValueObject {
  final List<RebalanceResultItem> _items = <RebalanceResultItem>[];
  final Amount _totalValue = Amount(0);

  UnmodifiableListView<RebalanceResultItem> get items => UnmodifiableListView(_items);
  Amount get totalValue => _totalValue;

  RebalanceResult(Map<String, Map<String, dynamic>> assetsToBuy, List<Asset> assets, List<Price> prices) {
    assetsToBuy.keys.forEach((key) {
      final ticker = key;
      final symbol = assets.firstWhere((e) => e.company.ticker == ticker).company.symbol;
      final quantity = Quantity(assetsToBuy[key][kRebalanceQtd]);
      final price = prices.firstWhere((e) => e.ticker == ticker).lastPrice;
      final total = Amount(assetsToBuy[key][kRebalanceTotal]);
      _items.add(RebalanceResultItem(ticker, symbol, quantity, price, total));
      _totalValue.setValue(_totalValue.value + total.value);
    });
  }
}

class RebalanceResultItem {
  final String ticker;
  final String symbol;
  final Quantity quantity;
  final Amount price;
  final Amount total;
  RebalanceResultItem(this.ticker, this.symbol, this.quantity, this.price, this.total);
}
