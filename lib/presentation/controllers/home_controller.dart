import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class HomeController extends GetxController {
  bool _showModal = true;
  PageController pageController;
  RxInt _currentPage = 0.obs;
  UserUseCase _userUseCase;

  HomeController() {
    this.pageController = PageController(initialPage: _currentPage.value);
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
      (notification) => _showMessage(notification.message),
      (user) => _showMessage('Bem vindo(a)${" " + user?.name?.firstName}!', error: false),
    );
    _showModal = false;
  }

  void _showMessage(String message, {bool error: true}) {
    AppSnackbar.show(message: message, type: error ? AppSnackbarType.error : AppSnackbarType.success);
  }

  int get currentPage => _currentPage.value;

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