import 'package:get/get.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/models/rebalance.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class RebalanceController extends GetxController {
  AppDataController appDataController;
  CategoriesUseCase categoriesUseCase;
  RxBool _isRebalancing = false.obs;
  final Amount aportValue = Amount(300.0);
  final Quantity assetsMaxNumber = Quantity(3);
  final Quantity categoriesMaxNumber = Quantity(2);

  RebalanceController() {
    appDataController = Get.find();
    categoriesUseCase = Get.find();
  }

  @override
  void onInit() {
    appDataController.loadAllCategoryScores();
    super.onInit();
  }

  bool get isRebalancing => _isRebalancing.value;

  void setRebalancing(bool value) => _isRebalancing.value = value;

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
      AppSnackbar.show(
        message: 'Um ou mais dados estão sendo atualizados. \nEspere um instante e tente novamente...',
        type: AppSnackbarType.error,
      );
    } else {
      final app = appDataController;
      final rebalance = Rebalance();
      rebalance.registerWalletValues(app.assets, app.categoryScores, app.prices);
      rebalance.registerRebalanceValues(aportValue, assetsMaxNumber, categoriesMaxNumber);
      rebalance.start();
    }
    setRebalancing(false);
  }
}
