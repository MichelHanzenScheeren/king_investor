import 'package:get/get.dart';

class LoadDataController extends GetxController {
  RxBool _userLoad = false.obs;
  RxBool _categoriesLoad = false.obs;
  RxBool _categoryScoresLoad = false.obs;
  RxBool _walletsLoad = false.obs;
  RxBool _assetsLoad = false.obs;
  RxBool _pricesLoad = false.obs;

  RxString _currentWalletId = ''.obs;

  bool get userLoad => _userLoad.value;
  bool get categoriesLoad => _categoriesLoad.value;
  bool get categoryScoresLoad => _categoryScoresLoad.value;
  bool get walletsLoad => _walletsLoad.value;
  bool get assetsLoad => _assetsLoad.value;
  bool get pricesLoad => _pricesLoad.value;
  String get currentWalletId => _currentWalletId.value;

  void setUserLoad(bool value) => _userLoad.value = value;
  void setCategoriesLoad(bool value) => _categoriesLoad.value = value;
  void setCategoryScoresLoad(bool value) => _categoryScoresLoad.value = value;
  void setWalletsLoad(bool value) => _walletsLoad.value = value;
  void setAssetsLoad(bool value) => _assetsLoad.value = value;
  void setPricesLoad(bool value) => _pricesLoad.value = value;
  void setCurrentWaletId(String value) => _currentWalletId.value = value ?? '';
}