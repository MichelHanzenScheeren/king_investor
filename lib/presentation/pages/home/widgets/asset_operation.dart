import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_divider_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class AssetOperation extends StatelessWidget {
  final AppDataController appDataController = Get.find();
  final Quantity quantity = Quantity(1);
  final Amount amount = Amount(50.0, mustBeGreaterThanZero: true);
  final String dividerOperation;
  final Function(Quantity, Amount) onSave;

  AssetOperation({@required this.dividerOperation, @required this.onSave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      child: Builder(
        builder: (context) => CustomBottomSheetWidget(
          children: [
            CustomDividerWidget(text: 'Nova $dividerOperation de Ativo'),
            SizedBox(height: 8),
            GetX<HomeController>(
              didChangeDependencies: (state) => state.controller.clearSelecteds(),
              builder: (homeController) {
                return CustomDropdownWidget<Category>(
                  initialValue: homeController.selectedCategory,
                  onChanged: homeController.setSelectedCategory,
                  values: homeController.categoriesDropdown.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category?.name ?? '', style: TextStyle(color: Colors.black, fontSize: 16)),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 14),
            GetX<HomeController>(
              builder: (homeController) {
                return CustomDropdownWidget<Asset>(
                  onChanged: homeController.setSelectedAsset,
                  values: homeController.assetsDropDown.map((asset) {
                    return DropdownMenuItem<Asset>(
                      value: asset,
                      child: Text(asset?.company?.symbol ?? '', style: TextStyle(color: Colors.black, fontSize: 16)),
                    );
                  }).toList(),
                  initialValue: homeController.selectedAsset,
                );
              },
            ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Quantidade:  ',
              initialValue: '${quantity.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => quantity.setValueFromString(value),
              validator: (value) => quantity.isValid ? null : quantity.notifications.first.message,
            ),
            SizedBox(height: 14),
            CustomTextFieldWidget(
              prefixText: 'Custo (un.):  R\$ ',
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
                    onSave(quantity, amount);
                    Get.back();
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
