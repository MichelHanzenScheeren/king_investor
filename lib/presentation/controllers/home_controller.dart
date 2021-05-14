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
  List<Asset> _assetsDropDown = <Asset>[];
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

  List<Category> get categoriesDropdown {
    if (_categoriesDropdown.isEmpty) {
      _categoriesDropdown.add(_allCategory);
      _categoriesDropdown.addAll(_appDataController.usedCategories);
    }
    return _categoriesDropdown;
  }

  Asset get selectedAsset {
    if (_selectedAsset.value == null) _selectedAsset.value = assetsDropDown.first;
    return _selectedAsset.value;
  }

  List<Asset> get assetsDropDown {
    if (_assetsDropDown.isEmpty) {
      if (selectedCategory.objectId == '-1') {
        _assetsDropDown.addAll(_appDataController.assets);
      } else {
        final assets = _appDataController.assets;
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

  void setCurrentPage(int value) => _currentPage.value = value ?? 0;

  void jumpToPage(int page) {
    if (page != currentPage)
      pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.easeInOutCirc);
  }

  Future<void> saveAssetBuy(Quantity quantity, Amount amount) async {
    final Asset asset = _getAndValidateSelectedAsset();
    if (asset == null) return;
    asset.registerBuy(quantity, amount);
    if (_validOperation(asset)) await _updateAsset(asset);
  }

  Future<void> saveAssetSale(Quantity quantity, Amount amount) async {
    final Asset asset = _getAndValidateSelectedAsset();
    if (asset == null) return;
    asset.registerSale(quantity, amount);
    if (_validOperation(asset)) await _updateAsset(asset);
  }

  Future<void> saveAssetIncome(Quantity quantity, Amount amount) async {
    final Asset asset = _getAndValidateSelectedAsset();
    if (asset == null) return;
    asset.registerIncome(amount);
    if (_validOperation(asset)) await _updateAsset(asset);
  }

  Asset _getAndValidateSelectedAsset() {
    final Asset asset = _selectedAsset.value;
    if (asset == null || !asset.isValid) AppSnackbar.show(message: 'Ativo inválido', type: AppSnackbarType.error);
    return asset;
  }

  bool _validOperation(Asset asset) {
    if (asset.isValid) return true;
    AppSnackbar.show(message: asset.firstNotification, type: AppSnackbarType.error);
    return false;
  }

  Future<void> _updateAsset(Asset asset) async {
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
