import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';

class FilterController extends GetxController {
  AppDataController appDataController;
  final Category _allCategory = Category('-1', null, 'Todas as categorias', -1);
  final List<Category> _categoriesDropdown = <Category>[];
  final Rx<Category> _selectedCategory = Rx<Category>(null);
  List<Asset> _assetsDropDown = <Asset>[];
  final Rx<Asset> _selectedAsset = Rx<Asset>(null);

  FilterController() {
    appDataController = Get.find();
  }

  Category get selectedCategory {
    if (_selectedCategory.value == null) _selectedCategory.value = _allCategory;
    return _selectedCategory.value;
  }

  List<Category> get categoriesDropdown {
    if (_categoriesDropdown.isEmpty) {
      _categoriesDropdown.add(_allCategory);
      _categoriesDropdown.addAll(appDataController.usedCategories);
    } else if ((_categoriesDropdown.length + 1) != appDataController.usedCategories.length) {
      _categoriesDropdown.clear();
      _categoriesDropdown.add(_allCategory);
      _categoriesDropdown.addAll(appDataController.usedCategories);
      _seeIfNeedToUpdateCurrentCategory();
    }
    return _categoriesDropdown;
  }

  void _seeIfNeedToUpdateCurrentCategory() {
    if (!_categoriesDropdown.any((e) => e.objectId != selectedCategory.objectId))
      setSelectedCategory(categoriesDropdown.first);
  }

  Asset get selectedAsset {
    if (_selectedAsset.value == null) _selectedAsset.value = assetsDropDown.first;
    return _selectedAsset.value;
  }

  List<Asset> get assetsDropDown {
    if (_assetsDropDown.isEmpty) {
      if (selectedCategory.objectId == '-1') {
        _assetsDropDown.addAll(appDataController.assets);
      } else {
        final assets = appDataController.assets;
        _assetsDropDown.addAll(assets.where((e) => e?.category?.objectId == selectedCategory.objectId).toList());
      }
    }
    return _assetsDropDown;
  }

  void clearSelecteds() {
    _categoriesDropdown.clear();
    _assetsDropDown.clear();
    _selectedCategory.value = null;
    _selectedAsset.value = null;
  }

  void setSelectedCategory(Category category) {
    _selectedCategory.value = category;
    _assetsDropDown.clear();
    _selectedAsset.value = null;
  }

  void setSelectedAsset(Asset asset) => _selectedAsset.value = asset;
}
