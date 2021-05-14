import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/presentation/controllers/filter_controller.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dropdown_widget.dart';

class CustomFilterCardWidget extends StatelessWidget {
  final FilterController filterController;

  CustomFilterCardWidget(this.filterController);

  @override
  Widget build(BuildContext context) {
    return GetX<FilterController>(
      // didChangeDependencies: (state) => state.controller.clearSelecteds(),
      init: filterController,
      autoRemove: false,
      builder: (filterController) {
        return CustomCardWidget(
          children: [
            CustomDropdownWidget<Category>(
              initialValue: filterController.selectedCategory,
              onChanged: filterController.setSelectedCategory,
              values: filterController.categoriesDropdown.map((category) {
                return CustomDropdownItems<Category>(category, category?.name ?? '');
              }).toList(),
            ),
            SizedBox(height: 14),
            CustomDropdownWidget<Asset>(
              initialValue: filterController.selectedAsset,
              onChanged: filterController.setSelectedAsset,
              values: filterController.assetsDropDown.map((asset) {
                return CustomDropdownItems<Asset>(asset, asset?.company?.symbol ?? '');
              }).toList(),
            )
          ],
        );
      },
    );
  }
}
