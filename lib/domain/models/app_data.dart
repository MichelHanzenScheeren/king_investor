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
  final List<Category> _categories = <Category>[];
  final List<CategoryScore> _categoryScores = <CategoryScore>[];
  final List<Wallet> _wallets = <Wallet>[];
  final List<Company> _localSearch = <Company>[];
  final Map<String, Price> _prices = <String, Price>{};
  final Map<String, ExchangeRate> _exchangeRates = <String, ExchangeRate>{};

  /* CONSTRUCTOR */
  AppData() : super(null, null);

  /* GETERS */
  User get currentUser => _currentUser;

  String get currentUserId => currentUser?.objectId ?? '';

  bool get wasUpdated => _wasUpdated;

  UnmodifiableListView<Category> get categories => UnmodifiableListView<Category>(_categories);

  UnmodifiableListView<CategoryScore> get categoryScores => UnmodifiableListView<CategoryScore>(_categoryScores);

  UnmodifiableListView<Wallet> get wallets => UnmodifiableListView<Wallet>(_wallets);

  UnmodifiableListView<Company> get localSearch => UnmodifiableListView<Company>(_localSearch);

  Wallet getMainWallet() => _wallets.firstWhere((element) => element.isMainWallet, orElse: () => null);

  bool hasWallet(String objectId) => _wallets.any((element) => element.objectId == objectId);

  bool duplicatedMainWallet(Wallet wallet) => _wallets.any((element) => element.isMainWallet && wallet.isMainWallet);

  Wallet getWalletById(String objectId) => _wallets.firstWhere((element) => element.objectId == objectId);

  bool hasCategory(String objectId) => _categories.any((element) => element.objectId == objectId);

  bool containsPrice(String ticker) => _prices.containsKey(ticker?.toLowerCase());

  Price getPrice(String ticker) => _prices[ticker?.toLowerCase()];

  bool containsExchangeRates(String origin, String destiny) {
    return _exchangeRates.containsKey('$origin$destiny'.toLowerCase());
  }

  ExchangeRate getCopyOfExchangeRate(String origin, String destiny) {
    final aux = _exchangeRates['$origin$destiny'.toLowerCase()];
    return ExchangeRate(null, null, aux.origin, aux.destiny, Amount(aux.lastPrice.value));
  }

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
}
