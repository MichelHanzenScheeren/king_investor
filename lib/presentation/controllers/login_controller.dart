import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool _loading = false.obs;
  RxBool _showPassword = false.obs;

  bool get loading => _loading.value;
  bool get showPassword => _showPassword.value;

  set setLoading(bool value) => _loading.value = value ?? false;
  set setShowPassword(bool value) => _showPassword.value = value ?? false;
}
