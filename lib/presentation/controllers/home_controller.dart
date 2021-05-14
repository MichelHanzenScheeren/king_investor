import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class HomeController extends GetxController {
  AppDataController _appDataController;
  UserUseCase _userUseCase;
  AssetsUseCase _assetsUseCase;
  bool _showModal = true;
  PageController pageController;
  RxInt _currentPage = 0.obs;
  final Category _allCategory = Category('-1', null, 'Todas as categorias', -1);
  final List<Category> _categoriesDropdown = <Category>[];
  final Rx<Category> _selectedCategory = Rx<Category>(null);
  final Rx<Asset> _selectedAsset = Rx<Asset>(null);

  HomeController() {
    this.pageController = PageController(initialPage: _currentPage.value);
    _appDataController = Get.find();
    _userUseCase = Get.find();
    _assetsUseCase = Get.find();
  }

  @override
  void onReady() {
    super.onReady();
    if (_showModal) _showIntroDialog();
  }

  void _showIntroDialog() async {
    final response = await _userUseCase.currentUser();
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (user) => AppSnackbar.show(message: 'Bem vindo(a), ${user?.name?.firstName}!', type: AppSnackbarType.success),
    );
    _showModal = false;
  }

  int get currentPage => _currentPage.value;

  Category get selectedCategory {
    if (_selectedCategory.value == null) _selectedCategory.value = _allCategory;
    return _selectedCategory.value;
  }

  Asset get selectedAsset {
    if (_selectedAsset.value == null) _selectedAsset.value = _appDataController.assets.first;
    return _selectedAsset.value;
  }

  List<Category> get categoriesDropdown {
    if (_categoriesDropdown.isEmpty)
      _categoriesDropdown
        ..add(_allCategory)
        ..addAll(_appDataController.usedCategories);
    return _categoriesDropdown;
  }

  List<Asset> get assetsDropDown {
    List<Asset> result;
    if (selectedCategory.objectId == '-1') {
      result = _appDataController.assets;
    } else {
      result = _appDataController.assets.where((e) => e?.category?.objectId == selectedCategory.objectId).toList();
    }
    setSelectedAsset(result.first);
    return result;
  }

  void clearSelecteds() {
    _categoriesDropdown.clear();
    _selectedCategory.value = null;
    _selectedAsset.value = null;
  }

  void setSelectedCategory(Category category) => _selectedCategory.value = category;

  void setSelectedAsset(Asset asset) => _selectedAsset.value = asset;

  void setCurrentPage(int value) => _currentPage.value = value ?? 0;

  void jumpToPage(int page) {
    if (page != currentPage)
      pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.easeInOutCirc);
  }

  Future<void> saveAssetBuy(Quantity quantity, Amount amount) async {
    final Asset asset = _selectedAsset.value;
    if (asset == null || !asset.isValid)
      return AppSnackbar.show(message: 'Ativo inválido', type: AppSnackbarType.error);

    asset.registerBuy(quantity, amount);
    if (!asset.isValid) {
      AppSnackbar.show(message: 'Um ou mais dos valores fornecidos são inválidos', type: AppSnackbarType.error);
      return;
    }
    final response = await _assetsUseCase.updateAsset(asset);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.success),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
