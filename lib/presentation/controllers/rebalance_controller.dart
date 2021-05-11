import 'package:get/get.dart';
import 'package:king_investor/domain/models/category_score.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class RebalanceController extends GetxController {
  AppDataController appDataController;
  CategoriesUseCase categoriesUseCase;

  RebalanceController() {
    appDataController = Get.find();
    categoriesUseCase = Get.find();
  }

  @override
  void onInit() {
    appDataController.loadAllCategoryScores();
    super.onInit();
  }

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
}
