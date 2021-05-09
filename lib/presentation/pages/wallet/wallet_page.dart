import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/wallets_top_card.dart';

class WalletPage extends StatelessWidget {
  final walletController = WalletController();
  final LoadDataController loadController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        WalletsTopCard(loadController: loadController),
      ],
    );
  }
}
