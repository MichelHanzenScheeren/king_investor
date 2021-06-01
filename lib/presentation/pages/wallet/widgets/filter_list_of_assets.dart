import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';

class FilterListOfAssets extends StatelessWidget {
  final AppDataController appDataController = Get.find();
  final WalletController walletController;

  FilterListOfAssets(this.walletController);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (appDataController.isLoadingSomething || appDataController.isMissingData) return Container();
      return CustomCardWidget(
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        children: [
          CustomDropdownWidget<AssetsOrder>(
            prefixText: 'Ordenar por',
            initialValue: walletController.currentAssetOrder,
            onChanged: (item) => walletController.setAssetOrder(item!),
            values: _assetsOrderValues(),
          ),
        ],
      );
    });
  }

  List<CustomDropdownItems<AssetsOrder>> _assetsOrderValues() {
    final map = AssetsOrder.values.map(
      (order) => CustomDropdownItems(order, walletController.getAssetOrderDescription(order)),
    );
    return map.toList();
  }
}
