import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/performance.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

enum SelectedFilter { categories, assets }
enum SelectedOrder { alphabetic, bestResult, moreInvested, hasMoreMoney, moreSales, moreIncomes }

class EvolutionController extends GetxController {
  AppDataController appDataController;
  Rx<SelectedFilter> _selectedFilter = Rx<SelectedFilter>(SelectedFilter.categories);
  Rx<SelectedOrder> _selectedOrder = Rx<SelectedOrder>(SelectedOrder.alphabetic);

  EvolutionController() {
    appDataController = Get.find();
  }

  Performance getGeneralPerformance() {
    final performance = Performance(appDataController.assets, appDataController.prices);
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Performance getCategoryPerformance(Category category) {
    final performance = Performance(
      appDataController.assets.where((e) => e?.category?.objectId == category?.objectId).toList(),
      appDataController.prices,
    );
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Performance getAssetPerformance(Asset asset) {
    final performance = Performance(
      [asset],
      appDataController.prices,
    );
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Future<void> _showGeneralErrorSnackBar(String message) async {
    await Future.delayed(Duration(milliseconds: 500));
    AppSnackbar.show(message: message, type: AppSnackbarType.error);
  }

  List<Asset> filteredByCategory(Category category) {
    return appDataController.assets.where((e) => e?.category?.objectId == category?.objectId).toList();
  }

  SelectedFilter get selectedFilter => _selectedFilter.value;

  SelectedOrder get selectedOrder => _selectedOrder.value;

  String filterDescription(SelectedFilter filter) {
    if (filter == SelectedFilter.categories) return 'Categorias';
    return 'Ativos';
  }

  String orderDescription(SelectedOrder order) {
    if (order == SelectedOrder.alphabetic) return 'Alfabética';
    if (order == SelectedOrder.bestResult) return 'Melhor resultado';
    if (order == SelectedOrder.hasMoreMoney) return 'Mais dinheiro hoje';
    if (order == SelectedOrder.moreInvested) return 'Mais dinheiro investido';
    if (order == SelectedOrder.moreSales) return 'Mais lucro com venda';
    return 'Mais proventos';
  }

  void setSelectedFilter(SelectedFilter newSelected) => _selectedFilter.value = newSelected;

  void setSelectedOrder(SelectedOrder newSelected) => _selectedOrder.value = newSelected;
}
