import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class SearchController extends GetxController {
  final RxBool _load = false.obs;
  final RxBool _save = false.obs;
  final RxString _saveId = ''.obs;
  final RxList<Company> _companies = RxList<Company>();
  final List<Category> categories = <Category>[];
  final List<Asset> assets = <Asset>[];
  Rx<Category> _currentCategory = Rx<Category>(null);
  FinanceUseCase financeUseCase;
  CategoriesUseCase categoriesUseCase;
  LoadDataController loadDataController;
  AssetsUseCase assetsUseCase;

  SearchController() {
    financeUseCase = Get.find();
    categoriesUseCase = Get.find();
    loadDataController = Get.find();
    assetsUseCase = Get.find();
    _initialLoads();
  }

  bool get load => _load.value;
  bool get save => _save.value;
  String get saveId => _saveId.value;
  List<Company> get companies => _companies;
  Category get currentCategory => _currentCategory.value;
  bool isSavedAsset(String ticker) => assets.any((e) => e?.company?.ticker == ticker);

  void setLoad(bool value) => _load.value = value;
  void setSave(bool value) => _save.value = value;
  void setSaveId(String value) => _saveId.value = value;

  void setCompanies(List<Company> newCompanies) {
    _companies.clear();
    _companies.addAll(newCompanies);
  }

  void _initialLoads() async {
    setLoad(true);
    await search('', needSetLoad: false);
    await loadCategories();
    await loadAllAssets();
    setLoad(false);
  }

  Future<void> search(String value, {needSetLoad: true}) async {
    if (needSetLoad) setLoad(true);
    final response = await financeUseCase.search(value);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => setCompanies(list),
    );
    if (needSetLoad) setLoad(false);
  }

  Future<void> loadCategories() async {
    final response = await categoriesUseCase.getCategories();
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => categories.addAll(list),
    );
  }

  Future<void> loadAllAssets() async {
    final response = await assetsUseCase.getAssets(loadDataController.currentWallet?.objectId);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => assets.addAll(list),
    );
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
    if (company?.currency == 'BRL') {
      if (company?.securityType == 'Common Stock') return categories.where((e) => e.order == 0)?.first;
      if (company?.securityType == 'Closed-End Fund') return categories.where((e) => e.order == 1)?.first;
      return categories.where((e) => e.order == 2)?.first;
    } else if (company?.currency == 'USD') {
      if (company?.securityType == 'Common Stock') return categories.where((e) => e.order == 3)?.first;
      if (company?.securityType == 'Closed-End Fund') return categories.where((e) => e.order == 4)?.first;
      return categories.where((e) => e.order == 5)?.first;
    }
    return categories.where((e) => e.order == 6)?.first;
  }

  Future<void> saveAsset(company, quantity, amount, score) async {
    setSaveId(company?.objectId);
    setSave(true);
    final walletId = loadDataController.currentWallet?.objectId;
    Asset asset = Asset(null, null, company, currentCategory, amount, score, quantity, walletId);
    final response = await assetsUseCase.addAsset(asset);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (notification) {
        assets.add(asset);
        AppSnackbar.show(message: notification.message, type: AppSnackbarType.success);
      },
    );
    setSaveId('');
    setSave(false);
  }
}
