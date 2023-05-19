import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class SearchController extends GetxController {
  final RxBool _load = false.obs;
  final RxBool _save = false.obs;
  final RxString _saveId = ''.obs;
  final RxList<Company> _companies = RxList<Company>();
  Rx<Category> _currentCategory = Rx<Category>(null);
  FinanceUseCase financeUseCase;
  CategoriesUseCase categoriesUseCase;
  AppDataController appDataController;
  AssetsUseCase assetsUseCase;

  SearchController() {
    financeUseCase = Get.find();
    categoriesUseCase = Get.find();
    appDataController = Get.find();
    assetsUseCase = Get.find();
    search('', needSetLoad: false);
  }

  bool get load => _load.value;
  bool get save => _save.value;
  String get saveId => _saveId.value;
  List<Company> get companies => _companies;
  Category get currentCategory => _currentCategory.value;
  bool isSavedAsset(String ticker) =>
      appDataController.assets.any((e) => e?.company?.ticker == ticker);

  void setLoad(bool value) => _load.value = value;
  void setSave(bool value) => _save.value = value;
  void setSaveId(String value) => _saveId.value = value;

  void setCompanies(List<Company> newCompanies) {
    _companies.clear();
    _companies.addAll(newCompanies);
  }

  Future<void> search(String value, {needSetLoad = true}) async {
    setLoad(true);
    final response = await financeUseCase.search(value);
    response.fold(
      (notification) => AppSnackbar.show(
          message: notification.message, type: AppSnackbarType.error),
      (list) => setCompanies(list),
    );
    setLoad(false);
  }

  void setCurrentCategory({Category category, Company company}) {
    if (category != null) {
      _currentCategory.value = category;
    } else {
      Category newCategory = _getCategoryFromCompany(company);
      if (newCategory != null) _currentCategory.value = newCategory;
    }
  }

  Category _getCategoryFromCompany(Company company) {
    try {
      final categories = appDataController.categories;
      if (company?.currency == 'BRL') {
        if (company?.securityType == 'Common Stock')
          return categories.where((e) => e.order == 0)?.first;
        if (company?.securityType == 'Closed-End Fund')
          return categories.where((e) => e.order == 1)?.first;
        return categories.where((e) => e.order == 2)?.first;
      } else if (company?.currency == 'USD') {
        if (company?.securityType == 'Common Stock')
          return categories.where((e) => e.order == 3)?.first;
        if (company?.securityType == 'Closed-End Fund')
          return categories.where((e) => e.order == 4)?.first;
        return categories.where((e) => e.order == 5)?.first;
      }
      return categories.where((e) => e.order == 6)?.first;
    } catch (error) {
      return Category('-1', null, 'Desconhecido', -1);
    }
  }

  Future<void> saveAsset(company, quantity, amount, score) async {
    setSaveId(company?.objectId);
    setSave(true);
    final walletId = appDataController.currentWallet?.objectId;
    Asset asset = Asset(null, null, company, currentCategory, amount, score,
        quantity, walletId);
    final response = await assetsUseCase.addAsset(asset);
    response.fold(
      (notification) => AppSnackbar.show(
          message: notification.message, type: AppSnackbarType.error),
      (notification) {
        appDataController.assets.add(asset);
        AppSnackbar.show(
            message: notification.message, type: AppSnackbarType.success);
      },
    );
    setSaveId('');
    setSave(false);
  }
}
