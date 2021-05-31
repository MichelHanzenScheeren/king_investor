import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:king_investor/presentation/controllers/rebalance_controller.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class RebalanceForm extends StatelessWidget {
  final RebalanceController rebalanceController;

  RebalanceForm(this.rebalanceController);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aportValue = rebalanceController.aportValue;
    final maxAssets = rebalanceController.assetsMaxNumber;
    final maxCategories = rebalanceController.categoriesMaxNumber;
    return Form(child: Builder(
      builder: (context) {
        return CustomCardWidget(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          children: [
            SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.centerLeft,
              child: Text(
                'Valor do aporte',
                style: TextStyle(color: theme.primaryColorLight, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 6),
            CustomTextFieldWidget(
              prefixText: 'R\$  ',
              initialValue: '${rebalanceController.aportValue.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              textInputType: TextInputType.number,
              onChanged: (value) => aportValue.setValueFromString(value),
              validator: (value) => aportValue.isValid ? null : aportValue.firstNotification,
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.centerLeft,
              child: Text(
                'Quantidade máxima de ativos',
                style: TextStyle(color: theme.primaryColorLight, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 6),
            CustomTextFieldWidget(
              initialValue: '${maxAssets.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              textInputType: TextInputType.number,
              onChanged: (value) => maxAssets.setValueFromString(value),
              validator: (value) => maxAssets.isValid ? null : maxAssets.firstNotification,
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.centerLeft,
              child: Text(
                'Quantidade máxima de categorias',
                style: TextStyle(color: theme.primaryColorLight, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 6),
            CustomTextFieldWidget(
              initialValue: '${maxCategories.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              textInputType: TextInputType.number,
              onChanged: (value) => maxCategories.setValueFromString(value),
              validator: (value) => maxCategories.isValid ? null : maxCategories.firstNotification,
            ),
            SizedBox(height: 26),
            Obx(() {
              if (rebalanceController.isRebalancing) return LoadIndicatorWidget();
              return CustomButtonWidget(
                buttonText: 'REBALANCEAR CARTEIRA',
                textStyle: TextStyle(color: theme.hintColor, fontSize: 15, fontWeight: FontWeight.bold),
                onPressed: () {
                  if (!Form.of(context)!.validate()) return;
                  rebalanceController.doRebalance();
                },
              );
            }),
            SizedBox(height: 6),
          ],
        );
      },
    ));
  }
}
