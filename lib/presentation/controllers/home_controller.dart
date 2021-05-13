import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class HomeController extends GetxController {
  AppDataController _appDataController;
  UserUseCase _userUseCase;
  bool _showModal = true;
  PageController pageController;
  RxInt _currentPage = 0.obs;
  final Rx<Category> _selectedCategory = Rx<Category>(null);
  final Rx<Asset> _selectedAsset = Rx<Asset>(null);

  HomeController() {
    this.pageController = PageController(initialPage: _currentPage.value);
    _appDataController = Get.find();
    _userUseCase = Get.find();
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
    if (_selectedCategory.value == null) _selectedCategory.value = Category('-1', null, 'Todos', -1);
    return _selectedCategory.value;
  }

  Asset get selectedAsset {
    if (_selectedAsset.value == null) _selectedAsset.value = _appDataController.assets.first;
    return _selectedAsset.value;
  }

  List<Category> get categoriesDropdown {
    return <Category>[..._appDataController.categories]..add(Category('-1', null, 'Todos', -1));
  }

  List<Asset> get assetsDropDown {
    if (selectedCategory.objectId == '-1') return _appDataController.assets;
    return _appDataController.assets.where((e) => e?.category?.objectId == selectedCategory.objectId);
  }

  void setSelectedCategory(Category category) => _selectedCategory.value = category;

  void setSelectedAsset(Asset asset) => _selectedAsset.value = asset;

  void setCurrentPage(int value) => _currentPage.value = value ?? 0;

  void jumpToPage(int page) {
    if (page != currentPage)
      pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.easeInOutCirc);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
