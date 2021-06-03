import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/domain/value_objects/day_performance.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

enum AssetsOrder { alphabeticAZ, variationMaxToMin, priceMaxToMin }

class WalletController extends GetxController {
  late AppDataController appDatacontroller;
  late UserUseCase userUseCase;
  late WalletsUseCase walletsUseCase;
  bool get isValidData => appDatacontroller.wallets.isNotEmpty && appDatacontroller.categories.isNotEmpty;
  bool get isEmptyData => appDatacontroller.assets.isEmpty;
  Rx<AssetsOrder> _currentAssetOrder = Rx<AssetsOrder>(AssetsOrder.alphabeticAZ);

  WalletController() {
    appDatacontroller = Get.find();
    userUseCase = Get.find();
    walletsUseCase = Get.find();
  }

  AssetsOrder get currentAssetOrder => _currentAssetOrder.value;

  void setAssetOrder(AssetsOrder newAssetOrder) => _currentAssetOrder.value = newAssetOrder;

  String getAssetOrderDescription(AssetsOrder assetOrder) {
    switch (assetOrder) {
      case AssetsOrder.alphabeticAZ:
        return 'Símbolo';
      case AssetsOrder.variationMaxToMin:
        return 'Variação';
      case AssetsOrder.priceMaxToMin:
        return 'Preço';
    }
  }

  List<Category> validCategories() {
    return appDatacontroller.categories
        .where((category) => appDatacontroller.assets.any((asset) => asset.category.objectId == category.objectId))
        .toList();
  }

  List<Asset> getCategoryAssets(Category category) {
    final assets = appDatacontroller.assets.where((asset) => asset.category.objectId == category.objectId).toList();
    return _orderAssets(assets);
  }

  List<Asset> _orderAssets(List<Asset> assets) {
    if (currentAssetOrder == AssetsOrder.priceMaxToMin)
      assets.sort((a, b) => getPriceByTicker(b).lastPrice.value.compareTo(getPriceByTicker(a).lastPrice.value));
    else if (currentAssetOrder == AssetsOrder.variationMaxToMin)
      assets.sort((a, b) => getPriceByTicker(b).variation.value.compareTo(getPriceByTicker(a).variation.value));
    else if (currentAssetOrder == AssetsOrder.alphabeticAZ)
      assets.sort((a, b) => a.company.ticker.compareTo(b.company.ticker));
    return assets;
  }

  Price getPriceByTicker(Asset asset) {
    return appDatacontroller.prices.firstWhere(
      (price) => price.ticker == asset.company.ticker,
      orElse: () => Price.fromDefaultValues(asset.company.ticker),
    );
  }

  List<DayPerformanceResult> getDayPerformance() {
    try {
      final categories = appDatacontroller.usedCategories;
      final performance = DayPerformance(appDatacontroller.prices, appDatacontroller.assets, categories);
      return performance.measurePerformance();
    } catch (eror) {
      String message = 'Um erro inesperado impediu que o resumo de hoje fosse mostrado';
      AppSnackbar.show(message: message, type: AppSnackbarType.error);
      return [];
    }
  }

  String getFormattedDayOfPerformance() {
    DateTime date = appDatacontroller.prices.first.lastUpdate;
    appDatacontroller.prices.forEach((price) {
      if (price.lastUpdate.isAfter(date)) date = price.lastUpdate;
    });
    var model = DateFormat("dd/MM/yyyy");
    return '${model.format(date)}';
  }

  Future<void> changeCurrentWallet(Wallet wallet) async {
    appDatacontroller.setCurrentWalet(wallet);
    AppSnackbar.show(message: 'Carteira atual alterada.', type: AppSnackbarType.success);
    await appDatacontroller.loadAllAssets();
    appDatacontroller.loadAllPrices();
  }

  Future<void> changeMainWallet() async {
    final response = await walletsUseCase.changeMainWallet(appDatacontroller.currentWallet?.objectId);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        final current = appDatacontroller.currentWallet!;
        current.setMainWallet(true);
        appDatacontroller.setCurrentWalet(current);
        AppSnackbar.show(message: 'Carteira definida como principal.', type: AppSnackbarType.success);
      },
    );
  }

  Future<void> updateCurrentWalletName(String name) async {
    final current = appDatacontroller.currentWallet;
    if (name == current?.name) return;
    current!.setName(name);
    if (current.name != name) {
      AppSnackbar.show(message: 'Nome inválido.', type: AppSnackbarType.error);
    } else {
      final response = await walletsUseCase.updateWallet(current);
      response.fold(
        (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
        (notification) {
          appDatacontroller.setCurrentWalet(null);
          appDatacontroller.setCurrentWalet(current);
          AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
        },
      );
    }
  }

  Future<void> createWallet(String name) async {
    final userResponse = await userUseCase.currentUser();
    if (userResponse.isLeft()) {
      AppSnackbar.show(message: userResponse.fold(((l) => l.message), ((r) => '')), type: AppSnackbarType.error);
      return;
    }
    Wallet wallet = Wallet(null, null, false, name, userResponse.getOrElse(() => null)!.objectId);
    final response = await walletsUseCase.addWallet(wallet);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) async {
        appDatacontroller.loadAllWallets();
        appDatacontroller.setCurrentWalet(wallet);
        AppSnackbar.show(message: notification!.message, type: AppSnackbarType.success);
        await appDatacontroller.loadAllAssets();
      },
    );
  }
}
