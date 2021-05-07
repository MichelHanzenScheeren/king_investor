import 'package:dartz/dartz.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class LoadController extends GetxController {
  AnimationController control;
  Animation<double> curve;
  UserUseCase userUseCase;

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
      if (status == AnimationStatus.completed) control.dispose();
    });
  }

  void _loadCurrentUser() async {
    userUseCase.currentUser().then(_checkCUrrentUserResult).catchError((error) => print(error.toString()));
  }

  void _checkCUrrentUserResult(Either<Notification, User> result) {
    result.fold(
      (notification) => print('${notification.key}: ${notification.message}'),
      (user) => print('Success: $user'),
    );
  }

  void enableOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
