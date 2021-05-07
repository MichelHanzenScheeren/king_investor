import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class HomeController extends GetxController {
  bool _showModal = true;
  TabController tabController;
  UserUseCase _userUseCase;

  HomeController(TabController tabController) {
    this.tabController = tabController;
    _userUseCase = Get.find();
  }

  @override
  void onReady() {
    super.onReady();
    if (_showModal) _showIntroDialog();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _showIntroDialog() async {
    final response = await _userUseCase.currentUser();
    response.fold(
      (notification) => _showMessage(notification.message),
      (user) => _showMessage('Bem vindo(a)${" " + user?.name?.firstName}!', error: false),
    );
    _showModal = false;
  }

  void _showMessage(String message, {bool error: true}) {
    AppSnackbar.show(message: message, type: error ? AppSnackbarType.error : AppSnackbarType.success);
  }
}
