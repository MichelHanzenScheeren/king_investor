import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/filter_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_filter_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class EvolutionPage extends StatelessWidget {
  final filterController = FilterController();
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (appDataController.isLoadingSomething) return ListView(children: [SizedBox(height: 4), LoadCardWidget()]);
    final theme = Theme.of(context);
    return ListView(
      children: [
        SizedBox(height: 8),
        CustomCardWidget(
          children: [
            Text('Desempenho Geral', style: TextStyle(color: theme.hintColor, fontSize: 18)),
          ],
        ),
        CustomCardWidget(
          children: [
            CustomFilterCardWidget(filterController),
          ],
        )
      ],
    );
  }
}
