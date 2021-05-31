import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/categorized_list_of_assets.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/wallets_top_card.dart';

class WalletPage extends StatelessWidget {
  final AppDataController appDataController = Get.find();
  final WalletController walletController = WalletController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        WalletsTopCard(appDataController: appDataController, walletController: walletController),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Divider(color: Theme.of(context).primaryColorLight),
        ),
        CategorizedListOfAssets(appDataController: appDataController, walletController: walletController),
        SizedBox(height: 4),
      ],
    );
  }
}
