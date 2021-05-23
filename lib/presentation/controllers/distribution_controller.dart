import 'package:get/get.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';

const kGeralCategoryId = '-2';
const kAllCategoryId = '-1';

class DistributionController extends GetxController {
  AppDataController appDataController;
  List<Category> categoriesFilter = <Category>[];
  RxInt _selectedIndex = 0.obs;

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
}
