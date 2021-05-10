import 'package:get/get.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class SearchController extends GetxController {
  final RxBool _load = false.obs;
  final RxList<Company> _companies = RxList<Company>();
  FinanceUseCase financeUseCase;

  SearchController() {
    financeUseCase = Get.find();
    search('');
  }

  bool get load => _load.value;
  List<Company> get companies => _companies;

  void setLoad(bool value) => _load.value = value;

  void setCompanies(List<Company> newCompanies) {
    _companies.clear();
    _companies.addAll(newCompanies);
  }

  Future<void> search(String value) async {
    setLoad(true);
    final response = await financeUseCase.search(value);
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (list) => setCompanies(list),
    );
    setLoad(false);
  }
}
