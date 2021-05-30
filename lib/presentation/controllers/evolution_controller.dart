import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/performance.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

enum SelectedFilter { categories, assets }
enum SelectedOrder { alphabetic, totalInWallet, totalInvested, totalIncomes, totalSales, valorization, bestResult }

class EvolutionController extends GetxController {
  late AppDataController appDataController;
  Rx<SelectedFilter> _selectedFilter = Rx<SelectedFilter>(SelectedFilter.categories);
  Rx<SelectedOrder> _selectedOrder = Rx<SelectedOrder>(SelectedOrder.alphabetic);

  EvolutionController() {
    appDataController = Get.find();
  }

  Performance getGeneralPerformance() {
    final performance = Performance('general', assets: appDataController.assets, prices: appDataController.prices);
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Performance categoryPerformance(Category category) {
    final performance = Performance(
      category.name,
      assets: appDataController.assets.where((e) => e.category.objectId == category.objectId).toList(),
      prices: appDataController.prices,
    );
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Performance assetPerformance(Asset asset) {
    final performance = Performance(
      asset.company.symbol,
      assets: [asset],
      prices: appDataController.prices,
    );
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Future<void> _showGeneralErrorSnackBar(String message) async {
    await Future.delayed(Duration(milliseconds: 500));
    AppSnackbar.show(message: message, type: AppSnackbarType.error);
  }

  List<Asset> filteredByCategory(Category category) {
    return appDataController.assets.where((e) => e.category.objectId == category.objectId).toList();
  }

  void applySort(List<Performance> results, SelectedOrder order) {
    if (order == SelectedOrder.alphabetic)
      results.sort((a, b) => a.identifier.compareTo(b.identifier));
    else if (order == SelectedOrder.totalInWallet)
      results.sort((a, b) => b.totalInWallet.value.compareTo(a.totalInWallet.value));
    else if (order == SelectedOrder.totalInvested)
      results.sort((a, b) => b.totalInvested.value.compareTo(a.totalInvested.value));
    else if (order == SelectedOrder.totalIncomes)
      results.sort((a, b) => b.totalIncomes.value.compareTo(a.totalIncomes.value));
    else if (order == SelectedOrder.totalSales)
      results.sort((a, b) => b.totalSales.value.compareTo(a.totalSales.value));
    else if (order == SelectedOrder.valorization)
      results.sort((a, b) => b.assetsValorization.value.compareTo(a.assetsValorization.value));
    else if (order == SelectedOrder.bestResult)
      results.sort((a, b) => b.totalResultValue.value.compareTo(a.totalResultValue.value));
  }

  SelectedFilter get selectedFilter => _selectedFilter.value;

  SelectedOrder get selectedOrder => _selectedOrder.value;

  String filterDescription(SelectedFilter filter) {
    if (filter == SelectedFilter.categories) return 'Categorias';
    return 'Ativos';
  }

  String orderDescription(SelectedOrder order) {
    if (order == SelectedOrder.alphabetic) return 'Nome';
    if (order == SelectedOrder.totalInWallet) return 'Total na carteira';
    if (order == SelectedOrder.totalInvested) return 'Total investido';
    if (order == SelectedOrder.totalIncomes) return 'Proventos';
    if (order == SelectedOrder.totalSales) return 'Vendas';
    if (order == SelectedOrder.valorization) return 'Valorização';
    return 'Resultado';
  }

  void setSelectedFilter(SelectedFilter newSelected) => _selectedFilter.value = newSelected;

  void setSelectedOrder(SelectedOrder newSelected) => _selectedOrder.value = newSelected;
}
