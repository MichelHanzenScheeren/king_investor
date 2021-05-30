import 'package:collection/collection.dart' show IterableExtension;
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class AssetController extends GetxController {
  late AppDataController appDataController;
  late AssetsUseCase assetsUseCase;
  final Rx<Category?> _selectedCategory = Rx<Category?>(null);
  List<Category> _categories = <Category>[];
  Rx<Asset?> _asset = Rx<Asset?>(null);

  AssetController() {
    appDataController = Get.find();
    assetsUseCase = Get.find();
  }

  Asset? get asset => _asset.value;

  bool get isValid => _asset.value != null;

  bool get isLoadingSomething {
    return appDataController.walletsLoad || appDataController.assetsLoad || appDataController.pricesLoad;
  }

  Category? get selectedCategory => _selectedCategory.value;

  List<Category> getCategories() {
    if (_categories.isEmpty) {
      final aux = appDataController.categories.where((e) => e.objectId != selectedCategory!.objectId).toList();
      _categories.add(selectedCategory!);
      _categories.addAll(aux);
      _categories.sort((a, b) => a.order.compareTo(b.order));
    }
    return _categories;
  }

  void setSelectedCategory(Category category) => _selectedCategory.value = category;

  void registerInitialCategory(Category category) {
    _selectedCategory.value = category;
  }

  void registerAsset(String assetId) {
    final auxAsset = appDataController.assets.firstWhereOrNull((e) => e.objectId == assetId);
    if (auxAsset != null) _asset.value = auxAsset;
  }

  String getWalletName(String walletId) {
    final wallet = appDataController.wallets.firstWhereOrNull((e) => e.objectId == walletId);
    return wallet?.name ?? 'Desconhecida';
  }

  String getTotalInvested() {
    return Amount((asset!.quantity.value) * (asset!.averagePrice.value)).toMonetary(asset!.company.currency);
  }

  String getTotalInWallet() {
    final price = appDataController.prices.firstWhere((e) => e.ticker == asset!.company.ticker);
    final total = (asset!.quantity.value) * (price.lastPrice.value);
    return Amount(total).toMonetary(asset!.company.currency);
  }

  String getAssetResult() {
    final price = appDataController.prices.firstWhereOrNull((e) => e.ticker == asset!.company.ticker);
    final total = (asset!.quantity.value) * (price!.lastPrice.value);
    final cost = (asset!.quantity.value) * (asset!.averagePrice.value);
    final result = Amount(total - cost + (asset!.sales.value) + (asset!.incomes.value));
    return result.toMonetary(asset!.company.currency);
  }

  Future<void> deleteAsset() async {
    final result = await assetsUseCase.deleteAsset(appDataController.currentWallet!.objectId, asset!.objectId);
    result.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        appDataController.loadAllAssets();
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }

  Future<void> updateAsset(Asset updatedAsset) async {
    final response = await assetsUseCase.updateAsset(updatedAsset);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        appDataController.loadAllAssets();
        _asset.value = updatedAsset;
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }

  Price getAssetPrice() {
    final price = appDataController.prices.firstWhereOrNull((e) => e.ticker == asset!.company.ticker);
    if (price == null) return Price.fromDefaultValues(_asset.value?.company.ticker);
    return price;
  }
}
