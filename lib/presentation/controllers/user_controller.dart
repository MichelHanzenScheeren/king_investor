import 'package:get/get.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_routes.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class UserController extends GetxController {
  AppDataController appDataController;
  UserUseCase userUseCase;
  Rx<User> _user = Rx<User>(null);
  RxBool _userLoad = true.obs;

  UserController() {
    appDataController = Get.find();
    userUseCase = Get.find();
  }

  @override
  void onReady() {
    super.onReady();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (_user.value != null) return;
    final response = await userUseCase.currentUser();
    if (response.isRight()) _user.value = response.getOrElse(() => null);
    setUserLoad(false);
  }

  bool get userLoad => _userLoad.value;

  bool get validUSer => _user.value != null;

  User get user => _user.value;

  void setUserLoad(bool value) => _userLoad.value = value;

  Future<void> updateUserData() async {
    final auxUser = _user.value;
    final response = await userUseCase.updateUserData(auxUser);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
        _user.value = null;
        _user.value = auxUser;
      },
    );
  }

  Future<void> doLogout() async {
    final response = await userUseCase.logout();
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        Get.offAllNamed(AppRoutes.login);
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }

  Future<void> passwordReset() async {
    final response = await userUseCase.requestPasswordReset(_user.value?.email?.address);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        Get.back();
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
  }
}
