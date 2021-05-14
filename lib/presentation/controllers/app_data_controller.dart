import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class AppDataController extends GetxController {
  /* USE CASES */
  UserUseCase userUseCase;
  WalletsUseCase walletsUseCase;
  CategoriesUseCase categoriesUseCase;
  AssetsUseCase assetsUseCase;
  FinanceUseCase financeUseCase;

  /* OBSERVABLE VARIABLES */
  RxBool _userLoad = false.obs;
  RxBool _categoriesLoad = false.obs;
  RxBool _categoryScoresLoad = false.obs;
  RxBool _walletsLoad = false.obs;
  RxBool _assetsLoad = false.obs;
  RxBool _pricesLoad = false.obs;
  Rx<Wallet> _currentWallet = Rx<Wallet>(null);

  /* OBSERVABLE LISTS */
  RxList<Wallet> wallets = RxList<Wallet>([]);
  RxList<Category> categories = RxList<Category>([]);
  RxList<Asset> assets = RxList<Asset>([]);
  RxList<Price> prices = RxList<Price>([]);
  RxList<CategoryScore> categoryScores = RxList<CategoryScore>([]);

  /* CONSTRUCTOR */
  AppDataController() {
    userUseCase = Get.find();
    walletsUseCase = Get.find();
    categoriesUseCase = Get.find();
    assetsUseCase = Get.find();
    financeUseCase = Get.find();
  }

  /* GETTERS */
  bool get userLoad => _userLoad.value;
  bool get categoriesLoad => _categoriesLoad.value;
  bool get categoryScoresLoad => _categoryScoresLoad.value;
  bool get walletsLoad => _walletsLoad.value;
  bool get assetsLoad => _assetsLoad.value;
  bool get pricesLoad => _pricesLoad.value;
  bool get isLoadingSomething => _categoriesLoad.value || _walletsLoad.value || _assetsLoad.value || _pricesLoad.value;
  Wallet get currentWallet => _currentWallet.value;
  List<Category> get usedCategories {
    return categories.where((cat) => assets.any((item) => item?.category?.objectId == cat?.objectId)).toList();
  }

  /* SETTERS */
  void setUserLoad(bool value) => _userLoad.value = value;
  void setCategoriesLoad(bool value) => _categoriesLoad.value = value;
  void setCategoryScoresLoad(bool value) => _categoryScoresLoad.value = value;
  void setWalletsLoad(bool value) => _walletsLoad.value = value;
  void setAssetsLoad(bool value) => _assetsLoad.value = value;
  void setPricesLoad(bool value) => _pricesLoad.value = value;
  void setCurrentWalet(Wallet value) => _currentWallet.value = value;
  void setList(currentList, toAddValues) {
    currentList.clear();
    currentList.addAll(toAddValues);
  }

  /* LOAD DATA FUNCTIONS */
  Future<void> loadAllData() async {
    loadAllCategories();
    await loadAllWallets(replaceCurrentWallet: true);
    if (currentWallet == null) return;
    await loadAllAssets();
    loadAllPrices();
  }

  Future<void> loadAllCategories() async {
    setCategoriesLoad(true);
    final response = await categoriesUseCase.getCategories();
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) {
        setList(categories, list);
        sortCategories();
      },
    );
    setCategoriesLoad(false);
  }

  void sortCategories() {
    categories.sort((cat1, cat2) => cat1.order.compareTo(cat2.order));
  }

  Future<void> loadAllWallets({bool replaceCurrentWallet: false}) async {
    setWalletsLoad(true);
    final response = await walletsUseCase.getAllUserWallets();
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) {
        setList(wallets, list);
        if (replaceCurrentWallet) {
          Wallet current = wallets.firstWhere((e) => e.isMainWallet, orElse: () => wallets.first);
          setCurrentWalet(current);
        }
      },
    );
    setWalletsLoad(false);
  }

  Future<void> loadAllAssets() async {
    setAssetsLoad(true);
    final response = await assetsUseCase.getAssets(currentWallet?.objectId);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => setList(assets, list),
    );
    setAssetsLoad(false);
  }

  Future<void> loadAllPrices() async {
    if (assets.isEmpty) return <Price>[];
    setPricesLoad(true);
    final List<String> tickers = List<String>.generate(assets.length, (index) => assets[index]?.company?.ticker);
    final response = await financeUseCase.getPrices(tickers);
    response.fold((notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
        (list) {
      setList(prices, list);
      sortAssets();
    });
    setPricesLoad(false);
  }

  void sortAssets() {
    assets.sort((asset1, asset2) => asset1?.company?.ticker?.compareTo(asset2?.company?.ticker));
  }

  Future<void> loadAllCategoryScores() async {
    setCategoryScoresLoad(true);
    final response = await categoriesUseCase.getCategoryScores(currentWallet?.objectId);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => setList(categoryScores, list),
    );
    setCategoryScoresLoad(false);
  }
}
