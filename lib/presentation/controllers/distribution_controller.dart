import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/distribution.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

const kGeralCategoryId = '-2';
const kAllCategoryId = '-1';

class DistributionController extends GetxController {
  AppDataController appDataController;
  List<Category> categoriesFilter = <Category>[];
  RxInt _selectedIndex = 0.obs;
  List<DistributionResultItem> _currentDistributionItems = <DistributionResultItem>[];
  Rx<DistributionResultItem> _selectedResultItem = Rx<DistributionResultItem>(null);
  List<Color> colors = <Color>[
    Colors.deepPurple,
    Colors.purple,
    Colors.deepPurpleAccent,
    Colors.purpleAccent,
    Colors.indigo[400],
    Colors.pink[400],
    Colors.blue[800],
    Colors.purple[300],
    Colors.blueAccent[700],
    Colors.blue[700],
    Colors.deepPurple[300],
    Colors.purpleAccent[400],
    Colors.blue,
    Colors.indigo[700],
    Colors.pink[800],
  ];

  DistributionController() {
    appDataController = Get.find();
  }

  @override
  void onInit() {
    _loadCategoriesFilter();
    super.onInit();
  }

  void _loadCategoriesFilter() {
    categoriesFilter.clear();
    final geralCategory = Category(kGeralCategoryId, null, 'Categorias', int.parse(kGeralCategoryId));
    final allCategory = Category(kAllCategoryId, null, 'Todos os ativos', int.parse(kAllCategoryId));
    categoriesFilter.addAll([geralCategory, allCategory]);
    categoriesFilter.addAll(List.from(appDataController.usedCategories));
  }

  int get selectedIndex => _selectedIndex.value ?? 0;

  Category get selectedCategory => categoriesFilter[selectedIndex];

  void setSelectedFilter(Category category) => _selectedIndex.value = categoriesFilter.indexOf(category);

  DistributionResultItem get selectedResultItem => _selectedResultItem.value;

  DistributionResult getDistributionItems() {
    try {
      DistributionResult result = _getDistributionItems();
      _currentDistributionItems.clear();
      _currentDistributionItems.addAll(result.items);
      return result;
    } catch (error) {
      AppSnackbar.show(message: 'Um erro inesperado ocorreu, tente novamente.', type: AppSnackbarType.error);
      return DistributionResult([], Amount(0));
    }
  }

  DistributionResult _getDistributionItems() {
    final app = appDataController;
    if (selectedCategory.objectId == kGeralCategoryId)
      return Distribution().fromCategories(app.usedCategories, app.assets, app.prices);
    if (selectedCategory.objectId == kAllCategoryId) return Distribution().fromAssets(app.assets, app.prices);
    return Distribution().fromAssets(
      app.assets.where((e) => e.category.objectId == selectedCategory.objectId).toList(),
      app.prices,
    );
  }

  Color getColor(int index) => colors[index % colors.length];

  void setSelectedDistributionItem(PieTouchResponse pieTouchResponse) {
    if (pieTouchResponse.touchInput.down && pieTouchResponse.touchedSection != null) {
      int index = pieTouchResponse.touchedSection.touchedSectionIndex;
      if (index < 0 || index >= _currentDistributionItems.length) return;
      final selected = _currentDistributionItems[index];
      if (selected?.identifier == _selectedResultItem?.value?.identifier)
        _selectedResultItem.value = null;
      else
        _selectedResultItem.value = selected;
    }
  }
}
