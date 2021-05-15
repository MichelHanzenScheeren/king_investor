import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/filter_controller.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_divider_widget.dart';
import 'package:king_investor/presentation/widgets/custom_filter_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class AssetOperation extends StatelessWidget {
  final AppDataController appDataController = Get.find();
  final Quantity quantity = Quantity(1, mustBeGreaterThanZero: true);
  final Amount amount = Amount(50.0, mustBeGreaterThanZero: true);
  final String dividerOperation;
  final Function(Quantity, Amount, Asset) onSave;
  final bool isIncomeOperation;
  final filterController = FilterController();

  AssetOperation({@required this.dividerOperation, @required this.onSave, this.isIncomeOperation: false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      child: Builder(
        builder: (context) => CustomBottomSheetWidget(
          children: [
            CustomDividerWidget(text: 'Nova $dividerOperation de ativo'),
            SizedBox(height: 8),
            CustomFilterCardWidget(filterController),
            isIncomeOperation ? Container() : SizedBox(height: 14),
            isIncomeOperation
                ? Container()
                : CustomTextFieldWidget(
                    prefixText: 'Quantidade:  ',
                    initialValue: '${quantity.value}',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    textInputType: TextInputType.number,
                    onChanged: (value) => quantity.setValueFromString(value),
                    validator: (value) => quantity.isValid ? null : quantity.notifications.first.message,
                  ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: '${isIncomeOperation ? "Valor total" : "Preço"}:  R\$ ',
              initialValue: '${amount.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => amount.setValueFromString(value),
              validator: (value) => amount.isValid ? null : amount.notifications.first.message,
            ),
            SizedBox(height: 14),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.4,
                  backGroundColor: theme.primaryColorDark,
                  buttonText: 'CANCELAR',
                  textStyle: TextStyle(color: theme.primaryColor, fontSize: 15),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: Text(''),
                ),
                CustomButtonWidget(
                  width: MediaQuery.of(context).size.width * 0.4,
                  buttonText: 'SALVAR',
                  textStyle: TextStyle(color: theme.hintColor, fontSize: 15),
                  onPressed: () {
                    if (!Form.of(context).validate()) return;
                    Get.back();
                    onSave(quantity, amount, filterController.selectedAsset);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
