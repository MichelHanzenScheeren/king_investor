import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackbarType { success, error }

class AppSnackbar {
  AppSnackbar._();

  static void show({String message: '', AppSnackbarType type: AppSnackbarType.error}) {
    try {
      if (Get.isSnackbarOpen) Get.back();

      String _message = _getMessage(message, type);
      TextStyle style = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
      Get.snackbar(
        null,
        null,
        titleText: Container(),
        messageText: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(_message, style: style)],
        ),
        duration: Duration(seconds: type == AppSnackbarType.success ? 3 : 5),
        backgroundColor: type == AppSnackbarType.success ? Colors.green[400] : Colors.red[400],
        colorText: Colors.white,
        borderRadius: 15,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        isDismissible: true,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      );
    } catch (error) {
      print(error.toString());
    }
  }

  static String _getMessage(String message, AppSnackbarType type) {
    if (message.isNotEmpty) return message;
    return type == AppSnackbarType.success ? 'Operação concluída' : 'Não foi possível concluir a operação';
  }
}
