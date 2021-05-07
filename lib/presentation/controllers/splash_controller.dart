import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class SplashController extends GetxController {
  AnimationController control;
  Animation<double> curve;
  UserUseCase userUseCase;
  String _nextPage = '';

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
        await Future.delayed(Duration(milliseconds: 500));
        _goToNextPage(_nextPage.isNotEmpty);
      }
    });
  }

  void _loadCurrentUser() async {
    final response = await userUseCase.currentUser();
    response.fold(
      (notification) => print('${notification.key}: ${notification.message}'),
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
