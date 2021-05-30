import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/asset_controller.dart';
import 'package:king_investor/presentation/pages/asset/widgets/about_asset_register.dart';
import 'package:king_investor/presentation/pages/asset/widgets/about_company.dart';
import 'package:king_investor/presentation/pages/asset/widgets/about_prices.dart';
import 'package:king_investor/presentation/pages/asset/widgets/edit_asset_form.dart';
import 'package:king_investor/presentation/pages/asset/widgets/empty_asset_card.dart';
import 'package:king_investor/presentation/widgets/custom_button_widget.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/custom_dialog_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';

class AssetPage extends StatelessWidget {
  final String assetId = Get.arguments;
  final assetController = AssetController();

  AssetPage() {
    assetController.registerAsset(assetId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('KING INVESTOR', style: TextStyle(color: theme.hintColor)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (assetController.isLoadingSomething) return ListView(children: [SizedBox(height: 4), LoadCardWidget()]);
        if (!assetController.isValid) return EmptyAssetCard();
        final asset = assetController.asset!;
        return ListView(
          children: [
            SizedBox(height: 4),
            CustomCardWidget(
              children: [
                AboutAssetRegister(assetController),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CustomButtonWidget(
                        buttonText: 'EDITAR',
                        textStyle: TextStyle(color: theme.hintColor, fontSize: 16, fontWeight: FontWeight.bold),
                        onPressed: _editAsset,
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: CustomButtonWidget(
                        buttonText: 'APAGAR',
                        textStyle: TextStyle(color: theme.hintColor, fontSize: 16, fontWeight: FontWeight.bold),
                        backGroundColor: theme.errorColor,
                        borderColor: Colors.transparent,
                        onPressed: _deleteAsset,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomCardWidget(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              children: [
                AboutCompany(asset.company),
              ],
            ),
            CustomCardWidget(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              children: [
                AboutPrice(assetController),
              ],
            ),
            SizedBox(height: 12),
          ],
        );
      }),
    );
  }

  void _deleteAsset() {
    Get.dialog(CustomDialogWidget(
      title: 'Tem certeza que deseja apagar esse ativo?',
      textContent: 'Não é possível desfazer essa ação',
      confirmButtonText: 'APAGAR',
      onConfirm: () {
        Get.back();
        Get.back();
        assetController.deleteAsset();
      },
    ));
  }

  void _editAsset() {
    Get.bottomSheet(EditAssetForm(asset: assetController.asset!, assetController: assetController));
  }
}
