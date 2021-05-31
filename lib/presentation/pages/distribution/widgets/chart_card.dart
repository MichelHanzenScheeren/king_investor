import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/distribution_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class ChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<DistributionController>(
      builder: (controller) {
        final result = controller.getDistributionItems();
        if (result.items.isEmpty) CustomCardWidget(children: [Icon(Icons.warning, size: 150)]);
        return CustomCardWidget(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          children: [
            Text(
              'Valor Total: ${result.totalValue.toMonetary("BRL")}',
              style: TextStyle(color: theme.hintColor, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 18),
            AspectRatio(
              aspectRatio: 1.05,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  startDegreeOffset: 0,
                  pieTouchData: PieTouchData(touchCallback: controller.setSelectedDistributionItem),
                  sections: List.generate(result.items.length, (i) {
                    final items = result.items;
                    final isSelected = items[i].identifier == (controller.selectedResultItem?.identifier ?? null);
                    final style = TextStyle(
                      color: theme.hintColor,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                      fontSize: isSelected ? 15 : 13,
                    );
                    return PieChartSectionData(
                      color: controller.getColor(i),
                      value: items[i].percentageValue.value,
                      title: '',
                      radius: MediaQuery.of(context).size.width * (isSelected ? 0.88 : 0.84) / 2,
                      badgePositionPercentageOffset: isSelected ? 0.84 : 0.8,
                      badgeWidget: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.primaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(items[i].title, style: style),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
