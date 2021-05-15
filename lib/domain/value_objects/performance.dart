import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

class Performance extends ValueObject {
  final totalInWallet = Amount(0.0);
  final totalInvested = Amount(0.0);
  final totalIncomes = Amount(0.0);
  final totalSales = Amount(0.0);
  final assetsValorization = Amount(0.0);
  final totalResultValue = Amount(0.0);
  final totalResultPorcentage = Amount(0.0);

  List<Asset> _assets;
  List<Price> _prices;

  Performance(List<Asset> assets, List<Price> prices) {
    _applyWalletContracts(assets, prices);
    if (isValid) {
      _assets = List.from(assets);
      _prices = List.from(prices);
      _measurePerformance();
    }
  }

  void _applyWalletContracts(List<Asset> assets, List<Price> prices) {
    if (assets == null || assets.isEmpty) addNotification('Performance.assets', 'A lista de ativos não pode ser vazia');
    if (prices == null || prices.isEmpty) addNotification('Performance.prices', 'A lista de preços não pode ser vazia');
    if (!isValid) return;
    if (assets.any((e) => _containNull([e.category, e.averagePrice, e.quantity, e.incomes, e.sales, e.company])))
      addNotification('Performance.assets', 'Um ou mais ativos possuem dados inválidos');
    if (prices.any((e) => _containNull([e.lastPrice, e.ticker, e.variation])))
      addNotification('Performance.scores', 'Um ou mais preços dos ativos possuem dados inválidos');
    if (!isValid) return;
    if (assets.any((e) => !e.averagePrice.isValid || !e.sales.isValid || !e.incomes.isValid || !e.quantity.isValid))
      addNotification('Performance.assets', 'Um ou mais ativos possuem dados inválidos');
    if (prices.any((e) => !e.lastPrice.isValid || e.ticker.isEmpty || !e.variation.isValid))
      addNotification('Performance.scores', 'Um ou mais preços dos ativos possuem dados inválidos');
    if (!isValid) return;
    if (assets.any((e) => !prices.any((item) => item.ticker == e.company.ticker)))
      addNotification('Performance.assets', 'Um ou mais ativos não possuem preço');
  }

  bool _containNull(List elements) {
    for (int i = 0; i < elements.length; i++) if (elements[i] == null) return true;
    return false;
  }

  void _measurePerformance() {
    double auxIncomes = 0.0;
    double auxSales = 0.0;
    double auxTotalInvested = 0.0;
    double auxTotalValue = 0.0;
    for (int index = 0; index < _assets.length; index++) {
      final currentAsset = _assets[index];
      final currentPrice = _prices.firstWhere((element) => element.ticker == currentAsset.company.ticker);
      /* SUM INCOMES */
      auxIncomes += currentAsset.incomes.value;
      /* SUM SALES */
      auxSales += currentAsset.sales.value;
      /*  SUM TOTAL INVESTED */
      auxTotalInvested += (currentAsset.quantity.value * currentAsset.averagePrice.value);
      /* SUM TOTAL VALUE */
      auxTotalValue += (currentAsset.quantity.value * currentPrice.lastPrice.value);
    }
    totalIncomes.setValue(auxIncomes);
    totalSales.setValue(auxSales);
    totalInvested.setValue(auxTotalInvested);
    totalInWallet.setValue(auxTotalValue);
    assetsValorization.setValue(auxTotalValue - auxTotalInvested);
    totalResultValue.setValue(assetsValorization.value + totalSales.value + totalIncomes.value);
    totalResultPorcentage.setValue(totalResultValue.value * 100 / auxTotalInvested);
  }
}

// totalInvested: 400
// totalValue: 500
