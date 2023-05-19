import 'package:get/get.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/value_objects/name.dart';
import 'package:king_investor/domain/value_objects/password.dart';
import 'package:king_investor/domain/value_objects/email.dart';
import 'package:king_investor/presentation/static/app_routes.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class SignUpController extends GetxController {
  UserUseCase _userUseCase;
  RxBool _loading = false.obs;
  RxBool _showPassword = false.obs;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';

  SignUpController() {
    _userUseCase = Get.find();
  }

  bool get loading => _loading.value;
  bool get showPassword => _showPassword.value;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get password => _password;

  void setLoading(bool value) => _loading.value = value ?? false;
  void setShowPassword() => _showPassword.value = !_showPassword.value;
  void setFirstName(String value) => _firstName = value ?? '';
  void setLastName(String value) => _lastName = value ?? '';
  void setEmail(String value) => _email = value ?? '';
  void setPassword(String value) => _password = value ?? '';

  String firstNameValidator(String value) {
    final Name name = Name(value, 'New User');
    if (name.isValid) return null;
    return name.notifications.first.message;
  }

  String lastNameNameValidator(String value) {
    final Name name = Name('New User', value);
    if (name.isValid) return null;
    return name.notifications.first.message;
  }

  String emailValidator(String value) {
    final Email email = Email(value);
    if (email.isValid) return null;
    return email.notifications.first.message;
  }

  String passwordValidator(String value) {
    final Password password = Password(value);
    if (password.isValid) return null;
    return password.notifications.first.message;
  }

  Future<void> doSignUp() async {
    setLoading(true);
    if (!Password(_password).isValid ||
        !Email(_email).isValid ||
        !Name(_firstName, _lastName).isValid) {
      _showMessage('Um ou mais campos do formulário não são válidos');
    } else {
      final User user =
          User(null, null, Name(_firstName, _lastName), Email(_email));
      final response = await _userUseCase.signUp(user, _password);
      response.fold(
        (notification) => _showMessage(notification.message),
        (user) => Get.offNamed(AppRoutes.home),
      );
    }
    setLoading(false);
  }

  void _showMessage(String message, {bool error = true}) {
    AppSnackbar.show(
        message: message,
        type: error ? AppSnackbarType.error : AppSnackbarType.success);
  }

  void goToLoginPage() => Get.offNamed(AppRoutes.login);
}
