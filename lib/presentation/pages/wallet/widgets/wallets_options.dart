import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class WalletsOptions extends StatelessWidget {
  final WalletController walletController;
  final AppDataController appDataController;

  WalletsOptions({@required this.walletController, @required this.appDataController});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheetWidget(
      options: [
        CustomBottomSheetOption(
          text: 'Trocar de carteira',
          icon: Icons.account_balance_wallet_rounded,
          show: appDataController.wallets.length > 1,
          onTap: _changeWallet,
        ),
        CustomBottomSheetOption(
          icon: Icons.library_add_check,
          text: "Definir como carteira principal",
          show: !appDataController.currentWallet.isMainWallet,
          onTap: _defineMainWallet,
        ),
        CustomBottomSheetOption(
          icon: Icons.edit,
          text: "Editar carteira atual",
          onTap: () => _editCurrentWallet(Theme.of(context)),
        ),
        CustomBottomSheetOption(
          icon: Icons.add_box_rounded,
          text: "Criar nova carteira",
          onTap: () => _createWallet(Theme.of(context)),
        ),
      ],
    );
  }

  void _changeWallet() {
    Get.back();
    final current = appDataController.currentWallet;
    final wallets = appDataController.wallets.where((e) => e.objectId != current.objectId).toList();
    Get.bottomSheet(CustomBottomSheetWidget(
      options: List<CustomBottomSheetOption>.generate(
        wallets.length,
        (index) => CustomBottomSheetOption(
          text: '${index + 1}  -  ${wallets[index]?.name}',
          textSize: 18,
          onTap: () {
            Get.back();
            walletController.changeCurrentWallet(wallets[index]);
          },
        ),
      ),
    ));
  }

  void _defineMainWallet() {
    Get.back();
    walletController.changeMainWallet();
  }

  void _editCurrentWallet(ThemeData theme) {
    Get.back();
    Get.bottomSheet(
      CustomBottomSheetWidget(
        children: [
          SizedBox(height: 15),
          Text(
            'Editar carteira atual',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, color: theme.hintColor),
          ),
          SizedBox(height: 20),
          CustomTextFieldWidget(
            autoFocus: true,
            placeHolder: "Nome",
            initialValue: appDataController.currentWallet?.name,
            onSubmit: (name) {
              Get.back();
              walletController.updateCurrentWalletName(name);
            },
          ),
        ],
      ),
    );
  }

  void _createWallet(ThemeData theme) {
    Get.back();
    Get.bottomSheet(
      CustomBottomSheetWidget(
        children: [
          SizedBox(height: 15),
          Text(
            'Criar carteira',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, color: theme.hintColor),
          ),
          SizedBox(height: 20),
          CustomTextFieldWidget(
            autoFocus: true,
            placeHolder: "Nome da nova carteira",
            onSubmit: (name) {
              Get.back();
              walletController.createWallet(name);
            },
          ),
        ],
      ),
    );
  }
}
