import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class AssetController extends GetxController {
  AppDataController appDataController;
  AssetsUseCase assetsUseCase;
  Rx<Asset> _asset = Rx<Asset>(null);

  AssetController() {
    appDataController = Get.find();
    assetsUseCase = Get.find();
  }

  Asset get asset => _asset.value;

  bool get isValid => _asset.value != null;

  bool get isLoadingSomething {
    return appDataController.walletsLoad || appDataController.assetsLoad || appDataController.pricesLoad;
  }

  void registerAsset(String assetId) {
    final auxAsset = appDataController.assets.firstWhere((e) => e.objectId == assetId, orElse: () => null);
    if (auxAsset != null) _asset.value = auxAsset;
  }

  String getWalletName(String walletId) {
    final wallet = appDataController.wallets.firstWhere((e) => e.objectId == walletId, orElse: () => null);
    return wallet?.name ?? 'Desconhecida';
  }

  String getTotalInvested() {
    return Amount((asset.quantity.value ?? 0) * (asset.averagePrice?.value ?? 0)).toMonetary(asset.company?.currency);
  }

  String getTotalInWallet() {
    final price = appDataController.prices.firstWhere((e) => e.ticker == asset.company?.ticker, orElse: () => null);
    final total = (asset.quantity?.value ?? 0) * (price?.lastPrice?.value ?? 0);
    return Amount(total).toMonetary(asset.company?.currency);
  }

  String getAssetResult() {
    final price = appDataController.prices.firstWhere((e) => e.ticker == asset.company?.ticker, orElse: () => null);
    final total = (asset.quantity?.value ?? 0) * (price?.lastPrice?.value ?? 0);
    final cost = (asset.quantity?.value ?? 0) * (asset.averagePrice?.value ?? 0);
    final result = Amount(total - cost + (asset.sales?.value ?? 0) + (asset.incomes?.value ?? 0));
    return result.toMonetary(asset.company?.currency);
  }

  Future<void> deleteAsset() async {
    final result = await assetsUseCase.deleteAsset(appDataController?.currentWallet?.objectId, asset?.objectId);
    result.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        appDataController.loadAllAssets();
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }
}
