import 'package:flutter/material.dart';
import 'package:king_investor/presentation/controllers/asset_controller.dart';
import 'package:king_investor/presentation/widgets/custom_divider_widget.dart';
import 'package:king_investor/presentation/widgets/custom_flex_text.dart';

class AboutAssetRegister extends StatelessWidget {
  final AssetController assetController;

  AboutAssetRegister(this.assetController);

  @override
  Widget build(BuildContext context) {
    final asset = assetController.asset;
    final currency = asset.company?.currency ?? '';
    final walletName = assetController.getWalletName(asset.walletForeignKey);
    return Column(
      children: [
        CustomDividerWidget(
          text: 'Informações do cadastro',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          dividerColor: Theme.of(context).hintColor,
        ),
        CustomFlexText(
          texts: ['Carteira', walletName],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Categoria', asset?.category?.name],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Nota/peso', '${asset?.score?.value ?? ""}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Quantidade', '${asset.quantity?.value ?? ""} un.'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Preço médio', asset?.averagePrice?.toMonetary(currency)],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Total investido', assetController.getTotalInvested()],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Total na carteira hoje', assetController.getTotalInWallet()],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Vendas', asset?.sales?.toMonetary(currency)],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Proventos', asset?.incomes?.toMonetary(currency)],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        SizedBox(height: 4),
        CustomFlexText(
          texts: ['Lucro/prejuízo', assetController.getAssetResult()],
          alignment: MainAxisAlignment.spaceBetween,
          size: 20,
          weight: FontWeight.w800,
        ),
      ],
    );
  }
}
