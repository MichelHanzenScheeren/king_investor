import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/rebalance_controller.dart';
import 'package:king_investor/presentation/pages/rebalance/widgets/category_scores_expansion_tile.dart';
import 'package:king_investor/presentation/pages/rebalance/widgets/empty_rebalance_card.dart';
import 'package:king_investor/presentation/pages/rebalance/widgets/rebalance_form.dart';
import 'package:king_investor/presentation/pages/rebalance/widgets/rebalance_results_card.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class RebalancePage extends StatelessWidget {
  final AppDataController appDataController = Get.find();
  final RebalanceController rebalanceController = RebalanceController();

  @override
  Widget build(BuildContext context) {
    return GetX<RebalanceController>(
      init: rebalanceController,
      autoRemove: false,
      builder: (rebalanceController) {
        if (appDataController.categoryScoresLoad || appDataController.assetsLoad || appDataController.pricesLoad)
          return ListView(children: [Container(child: LoadCardWidget(), padding: EdgeInsets.only(top: 8))]);
        if (appDataController.assets.isEmpty)
          return ListView(children: [Container(child: EmptyERebalanceCard(), padding: EdgeInsets.only(top: 8))]);
        if (rebalanceController.containsRebalanceResults) return RebalanceResultsCard(rebalanceController);
        return ListView(
          children: [
            SizedBox(height: 8),
            CategoryScoresExpansionTile(rebalanceController),
            RebalanceForm(rebalanceController),
          ],
        );
      },
    );
  }
}
