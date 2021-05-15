import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/search_controller.dart';
import 'package:king_investor/presentation/widgets/custom_bottom_sheet_widget.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_divider_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';
import 'package:king_investor/presentation/widgets/custom_text_field_widget.dart';

class SaveAssetForm extends StatelessWidget {
  final Company company;
  final SearchController searchController;
  final Quantity quantity = Quantity(1);
  final Amount amount = Amount(50.0, mustBeGreaterThanZero: true);
  final Score score = Score(10);

  SaveAssetForm({@required this.company, @required this.searchController}) {
    searchController.setCurrentCategory(company: company);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = Get.find<AppDataController>().categories;
    return Form(
      child: Builder(
        builder: (context) => CustomBottomSheetWidget(
          children: [
            CustomDividerWidget(text: 'Inforações'),
            _basicRow('Símbolo', company?.symbol, theme),
            _basicRow('Nome', company?.name, theme),
            _basicRow('Bolsa', '${company?.exchange ?? ''} (${company?.country} - ${company?.currency ?? ''})', theme),
            CustomDividerWidget(text: 'Configurações adicionais'),
            SizedBox(height: 4),
            Obx(() {
              return CustomDropdownWidget<Category>(
                prefixText: 'Categoria',
                initialValue: searchController.currentCategory,
                onChanged: (category) => searchController.setCurrentCategory(category: category),
                values: categories.map((category) {
                  return CustomDropdownItems<Category>(category, category?.name ?? '');
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
            CustomTextFieldWidget(
              prefixText: 'Nota:  ',
              initialValue: '${score.value}',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              textInputType: TextInputType.number,
              onChanged: (value) => score.setValueFromString(value),
              validator: (value) => score.isValid ? null : score.notifications.first.message,
            ),
            SizedBox(height: 16),
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
                    searchController.saveAsset(company, quantity, amount, score);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _basicRow(String title, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
      child: Row(
        children: [
          Text((title ?? '') + ':', style: TextStyle(color: theme.primaryColorLight, fontSize: 15)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(color: theme.hintColor, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
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
