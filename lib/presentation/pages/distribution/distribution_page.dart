import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/distribution_controller.dart';
import 'package:king_investor/presentation/pages/distribution/widgets/chart_card.dart';
import 'package:king_investor/presentation/pages/distribution/widgets/chart_legend_card.dart';
import 'package:king_investor/presentation/pages/distribution/widgets/empty_distribution_card.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class DistributionPage extends StatelessWidget {
  final DistributionController distributionController = DistributionController();
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        GetX<DistributionController>(
          init: distributionController,
          builder: (distributionController) {
            if (appDataController.isLoadingSomething) return LoadCardWidget();
            if (appDataController.assets.isEmpty) return EmptyDistributionCard();
            return CustomCardWidget(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              children: [
                CustomDropdownWidget<Category>(
                  prefixText: 'Agrupar por',
                  initialValue: distributionController.selectedCategory,
                  onChanged: distributionController.setSelectedFilter,
                  values: _filterDropdownValues(),
                ),
              ],
            );
          },
        ),
        ChartCard(distributionController),
        ChartLegendCard(distributionController),
        SizedBox(height: 8),
      ],
    );
  }

  List<CustomDropdownItems<Category>> _filterDropdownValues() {
    final categories = distributionController.categoriesFilter;
    return List.generate(categories.length, (i) => CustomDropdownItems(categories[i], categories[i]?.name));
  }
}
