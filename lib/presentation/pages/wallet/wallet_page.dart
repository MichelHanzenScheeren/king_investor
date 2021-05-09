import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/categorized_list_of_assets.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/wallets_top_card.dart';

class WalletPage extends StatelessWidget {
  final LoadDataController loadController = Get.find();
  final WalletController walletController = WalletController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 8),
        WalletsTopCard(loadController: loadController),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Divider(color: Theme.of(context).primaryColorLight),
        ),
        CategorizedListOfAssets(loadController: loadController, walletController: walletController),
      ],
    );
  }
}
