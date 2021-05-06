import 'dart:collection';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/shared/models/model.dart';

class AppData extends Model {
  User _currentUser;
  bool _wasUpdated = false;
  final List<Wallet> _wallets = <Wallet>[];
  final List<Company> _localSearch = <Company>[];
  final List<Category> _categories = <Category>[];
  final Map<String, List<CategoryScore>> _categoryScores = <String, List<CategoryScore>>{};
  final Map<String, Price> _prices = <String, Price>{};
  final Map<String, ExchangeRate> _exchangeRates = <String, ExchangeRate>{};

  /* CONSTRUCTOR */
  AppData() : super(null, null);

  /* GETERS */
  User get currentUser => _currentUser;

  String get currentUserId => currentUser?.objectId ?? '';

  bool get wasUpdated => _wasUpdated;

  UnmodifiableListView<Wallet> get wallets => UnmodifiableListView<Wallet>(_wallets);

  UnmodifiableListView<Company> get localSearch => UnmodifiableListView<Company>(_localSearch);

  UnmodifiableListView<Category> get categories => UnmodifiableListView<Category>(_categories);

  bool containWallet(String objectId) => _wallets.any((element) => element.objectId == objectId);

  bool containCategory(String objectId) => _categories.any((element) => element.objectId == objectId);

  bool containPrice(String ticker) => _prices.containsKey(ticker?.toLowerCase());

  bool containExchangeRates(String origin, String destiny) {
    return _exchangeRates.containsKey('$origin$destiny'.toLowerCase());
  }

  bool containCategoryScores(String walletId) => _categoryScores.containsKey(walletId);

  Wallet getMainWallet() => _wallets.firstWhere((element) => element.isMainWallet, orElse: () => null);

  Wallet getWalletById(String objectId) => _wallets.firstWhere((element) => element.objectId == objectId);

  Price getPrice(String ticker) => _prices[ticker?.toLowerCase()];

  ExchangeRate getCopyOfExchangeRate(String origin, String destiny) {
    final aux = _exchangeRates['$origin$destiny'.toLowerCase()];
    return ExchangeRate(null, null, aux.origin, aux.destiny, Amount(aux.lastPrice.value));
  }

  UnmodifiableListView<CategoryScore> getCategoryScores(String walletId) {
    return UnmodifiableListView<CategoryScore>(_categoryScores[walletId]);
  }

  CategoryScore getSpecificCategoryScore(String walletId, String categoryId) {
    if (!_categoryScores.containsKey(walletId)) return null;
    if (_categoryScores[walletId].any((score) => score?.category?.objectId == categoryId))
      return _categoryScores[walletId].firstWhere((score) => score?.category?.objectId == categoryId);
    return null;
  }

  bool duplicatedMainWallet(Wallet wallet) => _wallets.any((element) => element.isMainWallet && wallet.isMainWallet);

  /* SETTERS */
  void registerUser(User newUser) => _currentUser = newUser;

  void updateCurrentUser(User updatedUser) {
    _currentUser = updatedUser;
    _wasUpdated = true;
  }

  void removeCurrentUser() {
    _wasUpdated = false;
    _categoryScores.clear();
    _wallets.clear();
    _localSearch.clear();
    _currentUser = null;
  }

  void registerWallets(List<Wallet> list) {
    _wallets.addAll(list);
  }

  void deleteWallet(Wallet wallet) {
    _wallets.remove(wallet);
  }

  void updateWallet(Wallet wallet) {
    int index = _wallets.indexWhere((item) => item.objectId == wallet.objectId);
    _wallets[index] = wallet;
  }

  Asset findAsset(String objectId) {
    Asset asset;
    _wallets.forEach((wallet) {
      if (wallet.hasAsset(objectId)) asset = wallet.getAsset(objectId);
    });
    return asset;
  }

  void registerCategories(List<Category> categories) {
    _categories.addAll(categories);
  }

  void registerLocalSearch(List<Company> results) {
    _localSearch.clear();
    _localSearch.addAll(results);
  }

  void registerPrice(String ticker, Price price) => _prices[ticker?.toLowerCase()] = price;

  void registerExchangeRate(String origin, String destiny, ExchangeRate value) {
    _exchangeRates['$origin$destiny'.toLowerCase()] = value;
  }

  void registerCategoryScores(String walletId, List<CategoryScore> list) {
    _categoryScores[walletId] = list;
  }

  void replaceCategoryScore(CategoryScore score) {
    final scores = _categoryScores[score.walletForeignKey];
    if (scores != null) {
      if (scores.any((element) => element.objectId == score.objectId)) {
        int index = scores.indexWhere((element) => element.objectId == score.objectId);
        scores[index] = score;
      } else {
        scores.add(score);
      }
    }
  }
}
