import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class WalletController extends GetxController {
  LoadDataController loadcontroller;
  WalletsUseCase walletsUseCase;
  CategoriesUseCase categoriesUseCase;
  AssetsUseCase assetsUseCase;
  List<Category> categories = <Category>[];
  List<Asset> assets = <Asset>[];
  bool isValidData = true;
  bool get isEmptyData => !(categories.isNotEmpty && assets.isNotEmpty);

  WalletController() {
    loadcontroller = Get.find();
    walletsUseCase = Get.find();
    categoriesUseCase = Get.find();
    assetsUseCase = Get.find();
    loadData();
  }

  Future<void> loadData() async {
    loadAllCategories();
    await loadAllWallets();
    if (loadcontroller.currentWallet == null) return;
    loadAllAssets(loadcontroller.currentWallet.objectId);
  }

  Future<List<Wallet>> loadAllWallets() async {
    List<Wallet> wallets = <Wallet>[];
    loadcontroller.setWalletsLoad(true);
    final response = await walletsUseCase.getAllUserWallets();
    response.fold(
      (notification) {
        isValidData = false;
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.error);
      },
      (list) => loadcontroller.currentWallet == null ? _defineCurrentWallet(list) : (wallets = list),
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

  List<Category> validCategories() {
    return categories
        .where((category) => assets.any((asset) => asset.category?.objectId == category.objectId))
        .toList();
  }

  List<Asset> getCategoryAssets(Category category) {
    return assets.where((asset) => asset.category?.objectId == category?.objectId).toList();
  }
}
