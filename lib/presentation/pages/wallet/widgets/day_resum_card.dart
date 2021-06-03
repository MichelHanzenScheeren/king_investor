import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_flex_text.dart';

class DayResumCard extends StatelessWidget {
  final WalletController walletController;
  final AppDataController appDataController = Get.find();

  DayResumCard(this.walletController);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      if (appDataController.isLoadingSomething || appDataController.isMissingData) return Container();
      final results = walletController.getDayPerformance();
      if (results.length == 0) return Container();
      final String performanceDate = walletController.getFormattedDayOfPerformance();
      return CustomCardWidget(
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        children: [
          SizedBox(height: 2),
          CustomFlexText(
            texts: ['Resumo - $performanceDate'],
            alignment: MainAxisAlignment.center,
            style: TextStyle(color: theme.hintColor, fontSize: 19, fontWeight: FontWeight.w700),
            showDivider: false,
          ),
          SizedBox(height: 10),
          Column(
            children: List.generate(results.length, (i) {
              Amount earnings = results[i].earnings;
              Amount variation = results[i].variation;
              final style = TextStyle(fontSize: 17, color: theme.hintColor, fontWeight: FontWeight.w500);
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 1, 4, 0),
                child: CustomFlexText(
                  texts: [results[i].identifier, '${earnings.toMonetary("BRL")}  (${variation.toPorcentage()})'],
                  alignment: MainAxisAlignment.spaceBetween,
                  size: 17,
                  individualStyles: [style, _getStyle(variation, style, theme)],
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  TextStyle _getStyle(Amount variation, TextStyle style, ThemeData theme) {
    if (variation.value == 0) return style;
    return style.copyWith(color: variation.value < 0 ? theme.errorColor : theme.hoverColor);
  }
}
