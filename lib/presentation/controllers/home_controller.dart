import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class HomeController extends GetxController {
  AppDataController appDataController;
  UserUseCase _userUseCase;
  AssetsUseCase _assetsUseCase;
  bool _showModal = true;
  PageController pageController;
  RxInt _currentPage = 0.obs;

  HomeController() {
    this.pageController = PageController(initialPage: _currentPage.value);
    appDataController = Get.find();
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

  void setCurrentPage(int value) => _currentPage.value = value ?? 0;

  void jumpToPage(int page) {
    if (page != currentPage)
      pageController.animateToPage(page, duration: Duration(milliseconds: 200), curve: Curves.easeInOutCirc);
  }

  Future<void> saveAssetBuy(Quantity quantity, Amount amount, Asset selectedAsset) async {
    if (!_validSelectedAsset(selectedAsset)) return;
    selectedAsset.registerBuy(quantity, amount);
    if (_validOperation(selectedAsset)) await _updateAsset(selectedAsset);
  }

  Future<void> saveAssetSale(Quantity quantity, Amount amount, Asset selectedAsset) async {
    if (!_validSelectedAsset(selectedAsset)) return;
    selectedAsset.registerSale(quantity, amount);
    if (_validOperation(selectedAsset)) await _updateAsset(selectedAsset);
  }

  Future<void> saveAssetIncome(Quantity quantity, Amount amount, Asset selectedAsset) async {
    if (!_validSelectedAsset(selectedAsset)) return;
    selectedAsset.registerIncome(amount);
    if (_validOperation(selectedAsset)) await _updateAsset(selectedAsset);
  }

  bool _validSelectedAsset(selectedAsset) {
    if (selectedAsset == null || !selectedAsset.isValid) {
      AppSnackbar.show(message: 'Ativo inválido', type: AppSnackbarType.error);
      return false;
    }
    return true;
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
      (notification) {
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
        appDataController.loadAllAssets();
      },
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
