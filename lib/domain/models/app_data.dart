import 'dart:collection';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/models/model.dart';

class AppData extends Model {
  User _currentUser;
  bool _wasUpdated = false;
  final List<Category> _categories = <Category>[];
  final List<CategoryScore> _categoryScores = <CategoryScore>[];
  final List<ExchangeRate> _exchangeRates = <ExchangeRate>[];
  final List<Wallet> _wallets = <Wallet>[];

  /* CONSTRUCTOR */
  AppData() : super(null, null);

  /* GETERS */
  User get currentUser => _currentUser;

  String get currentUserId => currentUser?.objectId ?? '';

  bool get wasUpdated => _wasUpdated;

  UnmodifiableListView<Category> get categories => UnmodifiableListView<Category>(_categories);

  UnmodifiableListView<CategoryScore> get categoryScores => UnmodifiableListView<CategoryScore>(_categoryScores);

  UnmodifiableListView<ExchangeRate> get exchangeRates => UnmodifiableListView<ExchangeRate>(_exchangeRates);

  UnmodifiableListView<Wallet> get wallets => UnmodifiableListView<Wallet>(_wallets);

  bool hasWallet(String objectId) => _wallets.any((element) => element.objectId == objectId);

  bool duplicatedMainWallet(Wallet wallet) => _wallets.any((element) => element.isMainWallet && wallet.isMainWallet);

  Wallet getWalletById(String objectId) => _wallets.firstWhere((element) => element.objectId == objectId);

  Wallet getMainWallet() => _wallets.firstWhere((element) => element.isMainWallet, orElse: () => null);

  /* SETTERS */
  void registerNewUser(User newUser) => _currentUser = newUser;

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
}
