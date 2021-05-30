import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class SplashController extends GetxController {
  late AnimationController control;
  late Animation<double> curve;
  late UserUseCase userUseCase;
  String _nextPage = '';
  RxString _error = ''.obs;

  String get error => _error.value;

  void setError(String value) => _error.value = value;

  void initialConfiguration() {
    _fixPortraitOrientation();
    _addAnimationListener();
    control.forward();
    userUseCase = Get.find();
    _loadCurrentUser();
  }

  void _fixPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _addAnimationListener() {
    control.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        control.dispose();
        await Future.delayed(Duration(milliseconds: 800));
        _goToNextPage(_nextPage.isNotEmpty);
      }
    });
  }

  void _loadCurrentUser() async {
    final response = await userUseCase.currentUser();
    response.fold(
      (notification) {
        if (notification.message.contains('Session')) {
          _nextPage = AppRoutes.login;
          _goToNextPage(control.isCompleted);
        } else {
          setError(notification.message);
        }
      },
      (user) {
        _nextPage = user == null ? AppRoutes.login : AppRoutes.home;
        _goToNextPage(control.isCompleted);
      },
    );
  }

  void _goToNextPage(bool canGo) {
    if (!canGo) return;
    _enableOrientation();
    Get.offNamed(_nextPage);
  }

  void _enableOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
