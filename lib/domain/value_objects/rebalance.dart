import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/rebalance_result.dart';
import 'package:king_investor/shared/value_objects/value_object.dart';

const String kRebalanceQtd = 'quantity';
const String kRebalanceTotal = 'total';

class Rebalance extends ValueObject {
  /* PUBLIC  */
  Map<String, Map<String, dynamic>> _assetsToBuy;
  List<String> _boughtCategories;

  /* PRIVATE  */
  bool _walletData = false;
  bool _rebalanceData = false;
  List<Asset> _assets;
  List<CategoryScore> _scores;
  List<Price> _prices;
  Amount _aportValue;
  Quantity _assetsMaxNumber;
  Quantity _categoriesMaxNumber;

  void registerWalletValues(List<Asset> assets, List<CategoryScore> scores, List<Price> prices) {
    _applyWalletContracts(assets, scores, prices);
    if (isValid) {
      _assets = List<Asset>.from(assets);
      _scores = List<CategoryScore>.from(scores);
      _prices = List<Price>.from(prices);
    }
    _walletData = true;
  }

  void _applyWalletContracts(List<Asset> assets, List<CategoryScore> scores, List<Price> prices) {
    if (assets == null || assets.isEmpty) addNotification('Rebalance.assets', 'A lista de ativos não pode ser vazia');
    if (scores == null || scores.isEmpty) addNotification('Rebalance.scores', 'A lista de notas não pode ser vazia');
    if (prices == null || prices.isEmpty) addNotification('Rebalance.prices', 'A lista de preços não pode ser vazia');
    if (!isValid) return;
    if (assets.any((e) => e.company == null || e.category == null || e.score == null || e.quantity == null))
      addNotification('Rebalance.assets', 'Um ou mais ativos possuem dados inválidos');
    if (scores.any((e) => e.category == null || e.score == null))
      addNotification('Rebalance.scores', 'Uma ou mais notas das categorias possuem dados inválidos');
    if (prices.any((e) => e.lastPrice == null || e.ticker == null))
      addNotification('Rebalance.scores', 'Um ou mais preços dos ativos possuem dados inválidos');
    if (!isValid) return;
    if (assets.any((e) => !e.company.isValid || !e.category.isValid || !e.score.isValid || !e.quantity.isValid))
      addNotification('Rebalance.assets', 'Um ou mais ativos possuem dados inválidos');
    if (scores.any((e) => !e.category.isValid || !e.score.isValid))
      addNotification('Rebalance.scores', 'Uma ou mais notas das categorias possuem dados inválidos');
    if (prices.any((e) => !e.lastPrice.isValid || e.ticker.isEmpty))
      addNotification('Rebalance.scores', 'Um ou mais preços dos ativos possuem dados inválidos');
    if (!isValid) return;
    if (assets.any((e) => !prices.any((item) => item.ticker == e.company.ticker)))
      addNotification('Rebalance.assets', 'Um ou mais ativos não possuem preço');
  }

  void registerRebalanceValues(Amount aportValue, Quantity assetsMaxNumber, Quantity categoriesMaxNumber) {
    _applyRebalanceContracts(aportValue, assetsMaxNumber, categoriesMaxNumber);
    if (isValid) {
      _aportValue = Amount(aportValue.value);
      _assetsMaxNumber = Quantity(assetsMaxNumber.value);
      _categoriesMaxNumber = Quantity(categoriesMaxNumber.value);
    }
    _rebalanceData = true;
  }

  void _applyRebalanceContracts(Amount aportValue, Quantity assetsMaxNumber, Quantity categoriesMaxNumber) {
    if (aportValue == null || assetsMaxNumber == null || categoriesMaxNumber == null)
      addNotification('Rebalance.start', 'Uma ou mais configurações de balanceamento são inválidas');
    if (!isValid) return;
    if (!aportValue.isValid || !assetsMaxNumber.isValid || !categoriesMaxNumber.isValid)
      addNotification('Rebalance.start', 'Uma ou mais configurações de balanceamento são inválidas');
  }

  Future<RebalanceResult> start() async {
    if (!isValid) throw Exception('Tentativa de rebalanceamento com dados inválidos!');
    if (!_walletData) throw Exception('Tentativa de rebalanceamento sem registrar os dados da carteira');
    if (!_rebalanceData) throw Exception('Tentativa de rebalanceamento sem registrar os dados do rebalanceamento');
    await _doRebalance();
    return RebalanceResult(_assetsToBuy, _assets, _prices);
  }

  Future<void> _doRebalance() async {
    await Future.delayed(Duration(milliseconds: 50));
    _removeInutilizedCategoryScores();
    _assetsToBuy = <String, Map<String, dynamic>>{}; // {tycker: {quantity, total}}
    _boughtCategories = <String>[]; // [idCategory1, idCategory2]

    while (true) {
      final individualAssetsTotalValue = _calculeIndividualAssetsTotalValue();
      final individualCategoriesTotalValue = _calculeIndividualCategoriesTotalValue(individualAssetsTotalValue);
      double totalValue = _calculeTotalValue(individualAssetsTotalValue);
      final individualCategoriesIdealValue = _calculeIndividualCategoriesIdealValue(totalValue);
      final individualAssetsIdealValue = _calculeIndividualAssetsIdealValue(individualCategoriesIdealValue);

      _filterValidCategoriesToBuy(individualCategoriesTotalValue, _boughtCategories);
      String categoryToBuyId = _getCategoryToBuy(individualCategoriesTotalValue, individualCategoriesIdealValue);
      _filterValidAssetsToBuy(individualAssetsTotalValue, _assetsToBuy);
      String assetToBuyTicker = _getAssetToBuy(categoryToBuyId, individualAssetsTotalValue, individualAssetsIdealValue);
      double priceOfToBuyAsset = _prices.firstWhere((element) => element.ticker == assetToBuyTicker).lastPrice.value;

      if (_aportValue.value - priceOfToBuyAsset < 0) break;
      if (_assetsToBuy.containsKey(assetToBuyTicker)) {
        _assetsToBuy[assetToBuyTicker][kRebalanceQtd] += 1;
        _assetsToBuy[assetToBuyTicker][kRebalanceTotal] += priceOfToBuyAsset;
      } else {
        _assetsToBuy[assetToBuyTicker] = <String, dynamic>{};
        _assetsToBuy[assetToBuyTicker][kRebalanceQtd] = 1;
        _assetsToBuy[assetToBuyTicker][kRebalanceTotal] = priceOfToBuyAsset;
        _assetsMaxNumber.setValue(_assetsMaxNumber.value - 1);
        if (!_boughtCategories.any((e) => e == categoryToBuyId)) {
          _boughtCategories.add(categoryToBuyId);
          _categoriesMaxNumber.setValue(_categoriesMaxNumber.value - 1);
        }
      }
      _aportValue.setValue(_aportValue.value - priceOfToBuyAsset);
    }
  }

  void _removeInutilizedCategoryScores() {
    _scores.removeWhere((score) => !_assets.any((asset) => asset.category.objectId == score.category.objectId));
  }

  Map<String, double> _calculeIndividualAssetsTotalValue() {
    final total = <String, double>{};
    _assets.forEach((asset) {
      final price = _prices.firstWhere((price) => price.ticker == asset.company.ticker);
      int quantity = _assetsToBuy.containsKey(price.ticker) ? _assetsToBuy[price.ticker][kQuantity] : 0;
      total[price.ticker] = ((asset.quantity.value + quantity) * price.lastPrice.value);
    });
    return total;
  }

  Map<String, double> _calculeIndividualCategoriesTotalValue(Map<String, double> individualAssetsTotalValue) {
    final map = <String, double>{};
    _scores.forEach((score) {
      map[score.category.objectId] = 0;
      final assets = _assets.where((e) => e.category.objectId == score.category.objectId).toList();
      assets.forEach((asset) => map[score.category.objectId] += individualAssetsTotalValue[asset.company.ticker]);
    });
    return map;
  }

  double _calculeTotalValue(Map<String, double> map) {
    double value = 0.0;
    map.keys.forEach((key) => value += map[key]);
    return value;
  }

  Map<String, double> _calculeIndividualAssetsIdealValue(Map<String, double> idealTotalCategoriesValue) {
    final map = <String, double>{};
    _assets.forEach((asset) {
      double totalScore = 0;
      _assets.where((e) => e.category.objectId == asset.category.objectId).forEach((e) => totalScore += e.score.value);
      int assetScoreValue = asset.score.value;
      map[asset.company.ticker] = idealTotalCategoriesValue[asset.category.objectId] * assetScoreValue / totalScore;
    });
    return map;
  }

  Map<String, double> _calculeIndividualCategoriesIdealValue(double totalValue) {
    double totalScore = 0;
    final map = <String, double>{};
    _scores.forEach((score) => totalScore += score.score.value);
    _scores.forEach((score) {
      int categoryScoreValue = score.score.value;
      map[score.category.objectId] = totalValue * categoryScoreValue / totalScore;
    });
    return map;
  }

  void _filterValidCategoriesToBuy(Map<String, double> map, List<String> _boughtCategories) {
    if (_categoriesMaxNumber.value == 0)
      map.removeWhere((key, value) => !_boughtCategories.any((element) => element == key));
  }

  String _getCategoryToBuy(Map<String, double> total, Map<String, double> ideal) {
    String id = total.keys.first;
    total.keys.forEach((key) {
      if ((ideal[key] - total[key]) > (ideal[id] - total[id])) id = key;
    });
    return id;
  }

  void _filterValidAssetsToBuy(Map<String, double> map, Map<String, dynamic> boughtAssets) {
    if (_assetsMaxNumber.value == 0)
      map.removeWhere((key, value) => !boughtAssets.keys.any((element) => element == key));
  }

  String _getAssetToBuy(String categoryId, Map<String, double> total, Map<String, double> ideal) {
    final filteredAssets = _assets.where((asset) => asset.category.objectId == categoryId).toList();
    final filteredKeys = total.keys.where((key) => filteredAssets.any((element) => element.company.ticker == key));
    String ticker = filteredKeys.first;
    filteredKeys.forEach((key) {
      if ((ideal[key] - total[key]) > (ideal[ticker] - total[ticker])) ticker = key;
    });
    return ticker;
  }
}
