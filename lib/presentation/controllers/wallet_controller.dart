import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class WalletController extends GetxController {
  AppDataController loadcontroller;
  UserUseCase userUseCase;
  WalletsUseCase walletsUseCase;
  bool get isEmptyData => !(loadcontroller.categories.isNotEmpty && loadcontroller.assets.isNotEmpty);
  bool get isValidData => loadcontroller.wallets.isNotEmpty && loadcontroller.assets.isNotEmpty;

  WalletController() {
    loadcontroller = Get.find();
    userUseCase = Get.find();
    walletsUseCase = Get.find();
    loadcontroller.loadAllData();
  }

  List<Category> validCategories() {
    return loadcontroller.categories
        .where((category) => loadcontroller.assets.any((asset) => asset.category?.objectId == category.objectId))
        .toList();
  }

  List<Asset> getCategoryAssets(Category category) {
    return loadcontroller.assets.where((asset) => asset.category?.objectId == category?.objectId).toList();
  }

  Price getPriceByTicker(String ticker) {
    return loadcontroller.prices.firstWhere(
      (price) => price?.ticker == ticker,
      orElse: () => Price.fromDefaultValues(ticker),
    );
  }

  Future<void> changeCurrentWallet(Wallet wallet) async {
    loadcontroller.setCurrentWalet(wallet);
    AppSnackbar.show(message: 'Carteira atual alterada.', type: AppSnackbarType.success);
    await loadcontroller.loadAllAssets();
    loadcontroller.loadAllPrices();
  }

  Future<void> changeMainWallet() async {
    final response = await walletsUseCase.changeMainWallet(loadcontroller.currentWallet?.objectId);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        final current = loadcontroller.currentWallet;
        current.setMainWallet(true);
        loadcontroller.setCurrentWalet(current);
        AppSnackbar.show(message: 'Carteira definida como principal.', type: AppSnackbarType.success);
      },
    );
  }

  Future<void> updateCurrentWalletName(String name) async {
    final current = loadcontroller.currentWallet;
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
      (notification) async {
        loadcontroller.setCurrentWalet(wallet);
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
        await loadcontroller.loadAllAssets();
      },
    );
  }
}
