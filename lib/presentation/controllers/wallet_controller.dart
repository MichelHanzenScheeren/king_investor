import 'package:get/get.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/static/app_snackbar.dart';

class WalletController extends GetxController {
  LoadDataController loadcontroller;
  WalletsUseCase walletsUseCase;
  final List<Wallet> _wallets = <Wallet>[];

  WalletController() {
    loadcontroller = Get.find();
    walletsUseCase = Get.find();
    loadWallets();
  }

  Future<void> loadWallets() async {
    loadcontroller.setWalletsLoad(true);
    final response = await walletsUseCase.getAllUserWallets();
    loadcontroller.setWalletsLoad(false);
    return response.fold(
      (notification) => AppSnackbar.show(message: notification.message, type: AppSnackbarType.error),
      (wallets) {
        if (loadcontroller.currentWalletId.isEmpty) _defineCurrentWallet(wallets);
        return _wallets.addAll(wallets);
      },
    );
  }

  Wallet getCurrentWallet() {
    return _wallets.firstWhere((e) => e.objectId == loadcontroller.currentWalletId, orElse: () => null);
  }

  void _defineCurrentWallet(List<Wallet> wallets) {
    String id = wallets.firstWhere((e) => e.isMainWallet, orElse: () => null)?.objectId;
    if (id == null)
      loadcontroller.setCurrentWaletId(wallets?.first?.objectId ?? '');
    else
      loadcontroller.setCurrentWaletId(id);
  }

  void setCurrentWalletIndex(int index) {
    loadcontroller.setCurrentWaletId(_wallets[index].objectId);
  }
}
