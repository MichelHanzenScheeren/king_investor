import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/distribution_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';

class ChartLegendCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<DistributionController>(
      builder: (distributionController) {
        if (distributionController.selectedResultItem == null) return Container();
        final style = TextStyle(color: theme.hintColor, fontWeight: FontWeight.w600, fontSize: 16);
        final selected = distributionController.selectedResultItem!;
        return CustomCardWidget(
          children: [
            _getText(
              'Item selecionado:',
              style.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
              alignment: MainAxisAlignment.center,
            ),
            SizedBox(height: 14),
            _getText('${selected.quantity.value}un. ${selected.title} X ${selected.price.toMonetary("BRL")}', style),
            SizedBox(height: 8),
            _getText(
              'Total: ${selected.totalValue.toMonetary("BRL")} (${selected.percentageValue.toPorcentage()})',
              style,
            ),
          ],
        );
      },
    );
  }

  Widget _getText(String title, TextStyle style, {MainAxisAlignment? alignment}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: alignment ?? MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              title,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
