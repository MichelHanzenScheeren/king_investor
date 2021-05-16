import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/value_objects/rebalance.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/rebalance_result.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class RebalanceController extends GetxController {
  AppDataController appDataController;
  CategoriesUseCase categoriesUseCase;
  AssetsUseCase assetsUseCase;
  RxBool _isRebalancing = false.obs;
  final Amount aportValue = Amount(300.0, mustBeGreaterThanZero: true);
  final Quantity assetsMaxNumber = Quantity(3, mustBeGreaterThanZero: true);
  final Quantity categoriesMaxNumber = Quantity(2, mustBeGreaterThanZero: true);
  Rx<RebalanceResult> _rebalanceResult = Rx<RebalanceResult>(null);
  RxBool _savingRebalanceResults = false.obs;

  RebalanceController() {
    appDataController = Get.find();
    categoriesUseCase = Get.find();
    assetsUseCase = Get.find();
  }

  @override
  void onInit() {
    appDataController.loadAllCategoryScores();
    super.onInit();
  }

  bool get isRebalancing => _isRebalancing.value;

  void setRebalancing(bool value) => _isRebalancing.value = value;

  bool get containsRebalanceResults => _rebalanceResult.value != null;

  RebalanceResult get rebalanceResult => _rebalanceResult.value;

  bool get savingRebalanceResults => _savingRebalanceResults.value;

  void setSavingRebalanceResults(bool value) => _savingRebalanceResults.value = value ?? false;

  Future<void> updateCategoryScore(CategoryScore categoryScore) async {
    final response = await categoriesUseCase.updateCategoryScores(categoryScore);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        int index = appDataController.categoryScores.indexWhere((e) => e?.objectId == categoryScore?.objectId);
        if (index != -1) appDataController.categoryScores[index] = categoryScore;
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }

  List<CategoryScore> getActiveCategoryScores() {
    final categoryScores = appDataController.categoryScores;
    final assets = appDataController.assets;
    return categoryScores
        .where((categoryScore) => assets.any((asset) => asset.category.objectId == categoryScore.category.objectId))
        .toList();
  }

  bool isLoadingSomething() {
    final app = appDataController;
    return app.walletsLoad || app.assetsLoad || app.pricesLoad || app.categoryScoresLoad || app.userLoad;
  }

  Future<void> doRebalance() async {
    setRebalancing(true);
    if (isLoadingSomething()) {
      final String message = 'Um ou mais dados estão sendo atualizados. \nEspere um instante e tente novamente...';
      AppSnackbar.show(message: message, type: AppSnackbarType.error);
    } else {
      final app = appDataController;
      final rebalance = Rebalance();
      rebalance.registerWalletValues(app.assets, app.categoryScores, app.prices);
      rebalance.registerRebalanceValues(aportValue, assetsMaxNumber, categoriesMaxNumber);
      if (!rebalance.isValid) {
        final String message = 'Não foi possível concluir o rebalanceamento por conta de dados inválidos';
        AppSnackbar.show(message: message, type: AppSnackbarType.error);
      } else {
        await _doRebalance(rebalance);
      }
    }
    setRebalancing(false);
  }

  Future<void> _doRebalance(Rebalance rebalance) async {
    try {
      _rebalanceResult.value = await rebalance.start();
    } catch (erro) {
      AppSnackbar.show(message: 'Não foi possível concluir o rebalanceamento...', type: AppSnackbarType.error);
    }
  }

  Future<void> saveRebalance() async {
    if (!containsRebalanceResults)
      return AppSnackbar.show(message: 'Nenhum dado de rebalanceamento disponível', type: AppSnackbarType.error);
    if (rebalanceResult.items.isEmpty)
      return AppSnackbar.show(message: 'O rebalanceamento não possui itens', type: AppSnackbarType.error);
    setSavingRebalanceResults(true);
    bool success = true;
    for (int index = 0; index < rebalanceResult.items.length; index++) {
      final element = rebalanceResult.items[index];
      Asset asset = appDataController.assets.where((asset) => asset?.company?.ticker == element?.ticker)?.first;
      if (asset == null) {
        success = false;
      } else {
        asset.registerBuy(element.quantity, element.price);
        final result = await assetsUseCase.updateAsset(asset);
        if (result.isLeft()) success = false;
      }
    }
    if (success) {
      AppSnackbar.show(message: 'Alterações salvas', type: AppSnackbarType.success);
      clearResults();
    } else {
      AppSnackbar.show(message: 'Um ou mais ativos não puderam ser atualizados', type: AppSnackbarType.error);
    }
    setSavingRebalanceResults(false);
  }

  void clearResults() {
    _rebalanceResult.value = null;
  }
}
