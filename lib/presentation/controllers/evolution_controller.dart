import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/performance.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class EvolutionController extends GetxController {
  AppDataController appDataController;

  EvolutionController() {
    appDataController = Get.find();
  }

  Performance getGeneralPerformance() {
    final performance = Performance(appDataController.assets, appDataController.prices);
    if (!performance.isValid) _showGeneralErrorSnackBar(performance.firstNotification);
    return performance;
  }

  Future<void> _showGeneralErrorSnackBar(String message) async {
    await Future.delayed(Duration(milliseconds: 500));
    AppSnackbar.show(message: message, type: AppSnackbarType.error);
  }
}
