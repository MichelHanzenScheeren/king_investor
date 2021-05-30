import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/presentation/controllers/asset_controller.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class EditAssetForm extends StatelessWidget {
  final Asset asset;
  final AssetController assetController;
  final Quantity quantity = Quantity(1);
  final Amount averagePrice = Amount(50.0, mustBeGreaterThanZero: true);
  final Score score = Score(10);
  final Amount incomes = Amount(0.0);
  final Amount sales = Amount(0.0);

  EditAssetForm({required this.asset, required this.assetController}) {
    assetController.registerInitialCategory(asset.category);
    quantity.setValue(asset.quantity.value);
    averagePrice.setValue(asset.averagePrice.value);
    score.setValue(asset.score.value);
    incomes.setValue(asset.incomes.value);
    sales.setValue(asset.sales.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      child: Builder(
        builder: (context) => CustomBottomSheetWidget(
          children: [
            SizedBox(height: 12),
            Obx(() {
              return CustomDropdownWidget<Category?>(
                prefixText: 'Categoria',
                initialValue: assetController.selectedCategory,
                onChanged: (cat) => assetController.setSelectedCategory(cat!),
                values: assetController.getCategories().map((category) {
                  return CustomDropdownItems<Category>(category, category.name);
                }).toList(),
              );
            }),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Quantidade:  ',
              initialValue: '${quantity.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => quantity.setValueFromString(value),
              validator: (value) => quantity.isValid ? null : quantity.firstNotification,
            ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Preço médio:  R\$ ',
              initialValue: '${averagePrice.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => averagePrice.setValueFromString(value),
              validator: (value) => averagePrice.isValid ? null : averagePrice.notifications.first.message,
            ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Nota:  ',
              initialValue: '${score.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => score.setValueFromString(value),
              validator: (value) => score.isValid ? null : score.notifications.first.message,
            ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Vendas:  R\$ ',
              initialValue: '${sales.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => sales.setValueFromString(value),
              validator: (value) => sales.isValid ? null : sales.notifications.first.message,
            ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Proventos:  R\$ ',
              initialValue: '${incomes.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => incomes.setValueFromString(value),
              validator: (value) => incomes.isValid ? null : incomes.notifications.first.message,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.4,
                    backGroundColor: theme.primaryColorDark,
                    buttonText: 'CANCELAR',
                    textStyle: TextStyle(color: theme.primaryColor, fontSize: 15),
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: CustomButtonWidget(
                    width: MediaQuery.of(context).size.width * 0.4,
                    buttonText: 'SALVAR',
                    textStyle: TextStyle(color: theme.hintColor, fontSize: 15),
                    onPressed: () {
                      if (!(Form.of(context)?.validate() ?? false)) return;
                      Get.back();
                      final aux = Asset(
                        asset.objectId,
                        asset.createdAt,
                        asset.company,
                        assetController.selectedCategory!,
                        averagePrice,
                        score,
                        quantity,
                        asset.walletForeignKey,
                        incomes: incomes,
                        sales: sales,
                      );
                      assetController.updateAsset(aux);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldLabel(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(color: theme.hintColor, fontSize: 16), textAlign: TextAlign.left),
    );
  }
}
