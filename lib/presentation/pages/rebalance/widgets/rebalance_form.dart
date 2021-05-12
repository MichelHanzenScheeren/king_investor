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
    final assetsMaxNumber = rebalanceController.assetsMaxNumber;
    final categoriesMaxNumber = rebalanceController.categoriesMaxNumber;
    return Form(child: Builder(
      builder: (context) {
        return CustomCardWidget(
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
              validator: (value) => aportValue.isValid ? null : aportValue.notifications.first.message,
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
              initialValue: '${assetsMaxNumber.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              textInputType: TextInputType.number,
              onChanged: (value) => assetsMaxNumber.setValueFromString(value),
              validator: (value) => assetsMaxNumber.isValid ? null : assetsMaxNumber.notifications.first.message,
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
              initialValue: '${categoriesMaxNumber.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              textInputType: TextInputType.number,
              onChanged: (value) => categoriesMaxNumber.setValueFromString(value),
              validator: (value) =>
                  categoriesMaxNumber.isValid ? null : categoriesMaxNumber.notifications.first.message,
            ),
            SizedBox(height: 26),
            Obx(() {
              if (rebalanceController.isRebalancing) return LoadIndicatorWidget();
              return CustomButtonWidget(
                buttonText: 'REBALANCEAR CARTEIRA',
                textStyle: TextStyle(color: theme.hintColor, fontSize: 15, fontWeight: FontWeight.bold),
                onPressed: rebalanceController.doRebalance,
              );
            }),
            SizedBox(height: 6),
          ],
        );
      },
    ));
  }
}
