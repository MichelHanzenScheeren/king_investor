import 'package:get/get.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class WalletController extends GetxController {
  LoadDataController loadcontroller;
  WalletsUseCase walletsUseCase;

  WalletController() {
    loadcontroller = Get.find();
    walletsUseCase = Get.find();
    loadWallets();
  }

  Future<void> loadWallets() async {
    loadcontroller.setWalletsLoad(true);
    final response = await walletsUseCase.getAllUserWallets();
    response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (wallets) => loadcontroller.currentWallet == null ? _defineCurrentWallet(wallets) : null,
    );
    loadcontroller.setWalletsLoad(false);
  }

  void _defineCurrentWallet(List<Wallet> wallets) {
    Wallet current = wallets.firstWhere((e) => e.isMainWallet, orElse: () => null);
    loadcontroller.setCurrentWalet(current);
  }
}
