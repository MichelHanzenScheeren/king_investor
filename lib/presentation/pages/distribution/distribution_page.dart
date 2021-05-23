import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/distribution_controller.dart';
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
            return Column(
              children: [
                CustomCardWidget(
                  margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  children: [
                    CustomDropdownWidget<Category>(
                      prefixText: 'Agrupar por',
                      initialValue: distributionController.selectedCategory,
                      onChanged: distributionController.setSelectedFilter,
                      values: _filterDropdownValues(),
                    ),
                  ],
                ),
                CustomCardWidget(
                  children: [
                    SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 1.1,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          startDegreeOffset: 0,
                          sections: List.generate(2, (index) {
                            return PieChartSectionData(
                              color: index == 0 ? Colors.purple : Colors.deepPurpleAccent,
                              value: 50.0,
                              title: 'Valor $index',
                              titleStyle: TextStyle(color: Theme.of(context).hintColor),
                              radius: MediaQuery.of(context).size.width * 0.7 / 2,
                              badgePositionPercentageOffset: 0.7,
                              titlePositionPercentageOffset: 1.1,
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<CustomDropdownItems<Category>> _filterDropdownValues() {
    final categories = distributionController.categoriesFilter;
    return List.generate(categories.length, (i) => CustomDropdownItems(categories[i], categories[i]?.name));
  }
}
