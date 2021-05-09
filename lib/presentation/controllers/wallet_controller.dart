import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class WalletController extends GetxController {
  LoadDataController loadcontroller;
  UserUseCase userUseCase;
  WalletsUseCase walletsUseCase;
  CategoriesUseCase categoriesUseCase;
  AssetsUseCase assetsUseCase;
  FinanceUseCase financeUseCase;
  List<Wallet> wallets = <Wallet>[];
  List<Category> categories = <Category>[];
  List<Asset> assets = <Asset>[];
  List<Price> prices = <Price>[];
  bool isValidData = true;
  bool get isEmptyData => !(categories.isNotEmpty && assets.isNotEmpty);

  WalletController() {
    loadcontroller = Get.find();
    userUseCase = Get.find();
    walletsUseCase = Get.find();
    categoriesUseCase = Get.find();
    assetsUseCase = Get.find();
    financeUseCase = Get.find();
    loadData();
  }

  Future<void> loadData() async {
    loadAllCategories();
    await loadAllWallets();
    if (loadcontroller.currentWallet == null) return;
    await loadAllAssets(loadcontroller.currentWallet.objectId);
    loadAllPrices();
  }

  Future<List<Wallet>> loadAllWallets() async {
    loadcontroller.setWalletsLoad(true);
    final response = await walletsUseCase.getAllUserWallets();
    response.fold(
      (notification) {
        isValidData = false;
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.error);
      },
      (list) {
        if (loadcontroller.currentWallet == null) _defineCurrentWallet(list);
        wallets = list;
      },
    );
    loadcontroller.setWalletsLoad(false);
    return wallets;
  }

  void _defineCurrentWallet(List<Wallet> wallets) {
    Wallet current = wallets.firstWhere((e) => e.isMainWallet, orElse: () => null);
    loadcontroller.setCurrentWalet(current);
  }

  Future<List<Category>> loadAllCategories() async {
    loadcontroller.setCategoriesLoad(true);
    final response = await categoriesUseCase.getCategories();
    response.fold(
      (notification) {
        isValidData = false;
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.error);
      },
      (list) => categories = list,
    );
    loadcontroller.setCategoriesLoad(false);
    return categories;
  }

  Future<List<Asset>> loadAllAssets(String walletId) async {
    loadcontroller.setAssetsLoad(true);
    final response = await assetsUseCase.getAssets(walletId);
    response.fold(
      (notification) {
        isValidData = false;
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.error);
      },
      (list) => assets = list,
    );
    loadcontroller.setAssetsLoad(false);
    return assets;
  }

  Future<List<Price>> loadAllPrices() async {
    loadcontroller.setPricesLoad(true);
    final List<String> tickers = List<String>.generate(assets.length, (index) => assets[index]?.company?.ticker);
    final response = await financeUseCase.getPrices(tickers);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => prices = list,
    );
    loadcontroller.setPricesLoad(false);
    return prices;
  }

  Wallet get currentWallet => loadcontroller.currentWallet;

  List<Category> validCategories() {
    return categories
        .where((category) => assets.any((asset) => asset.category?.objectId == category.objectId))
        .toList();
  }

  List<Asset> getCategoryAssets(Category category) {
    return assets.where((asset) => asset.category?.objectId == category?.objectId).toList();
  }

  Price getPriceByTicker(String ticker) {
    return prices.firstWhere((price) => price?.ticker == ticker, orElse: () => Price.fromDefaultValues(ticker));
  }

  Future<void> changeCurrentWallet(Wallet wallet) async {
    loadcontroller.setCurrentWalet(wallet);
    AppSnackbar.show(message: 'Carteira atual alterada.', type: AppSnackbarType.success);
    await loadAllAssets(wallet?.objectId);
    loadAllPrices();
  }

  Future<void> changeMainWallet() async {
    final response = await walletsUseCase.changeMainWallet(currentWallet?.objectId);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        final current = currentWallet;
        current.setMainWallet(true);
        loadcontroller.setCurrentWalet(current);
        AppSnackbar.show(message: 'Carteira definida como principal.', type: AppSnackbarType.success);
      },
    );
  }

  Future<void> updateCurrentWalletName(String name) async {
    final current = currentWallet;
    if (name == current?.name) return;
    current.setName(name);
    if (current.name != name) {
      AppSnackbar.show(message: 'Nome inválido.', type: AppSnackbarType.error);
    } else {
      final response = await walletsUseCase.updateWallet(current);
      response.fold(
        (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
        (notification) {
          loadcontroller.setCurrentWalet(null);
          loadcontroller.setCurrentWalet(current);
          AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
        },
      );
    }
  }

  Future<void> createWallet(String name) async {
    final userResponse = await userUseCase.currentUser();
    if (userResponse.isLeft()) {
      AppSnackbar.show(message: userResponse.fold((l) => l.message, (r) => null), type: AppSnackbarType.error);
      return;
    }
    Wallet wallet = Wallet(null, null, false, name, userResponse.getOrElse(() => null)?.objectId);
    final response = await walletsUseCase.addWallet(wallet);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        loadcontroller.setCurrentWalet(wallet);
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }
}
