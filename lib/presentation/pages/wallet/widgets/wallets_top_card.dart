import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/wallets_options.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class WalletsTopCard extends StatelessWidget {
  final AppDataController appDataController = Get.find();
  final WalletController walletController;

  WalletsTopCard(this.walletController);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomCardWidget(
      direction: Axis.horizontal,
      children: <Widget>[
        Icon(Icons.account_balance_wallet),
        SizedBox(width: 15),
        Obx(() {
          if (appDataController.walletsLoad) return _awaiting();
          return Expanded(
            child: Text(
              appDataController.currentWallet?.name ?? "!",
              style: TextStyle(
                color: theme.primaryColorLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
        SizedBox(width: 15),
        GestureDetector(
          child: Icon(Icons.edit, size: 28),
          onTap: () => Get.bottomSheet(
            WalletsOptions(walletController: walletController, appDataController: appDataController),
          ),
        ),
      ],
    );
  }

  Widget _awaiting() {
    return Expanded(
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 10),
            child: LoadIndicatorWidget(size: 20, strokeWidth: 2, usePrimaryColor: false),
          ),
          Expanded(child: Text("")),
        ],
      ),
    );
  }
}
