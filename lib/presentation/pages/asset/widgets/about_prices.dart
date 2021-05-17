import 'package:flutter/material.dart';
import 'package:king_investor/presentation/controllers/asset_controller.dart';
import 'package:king_investor/presentation/widgets/custom_divider_widget.dart';
import 'package:king_investor/presentation/widgets/custom_flex_text.dart';

class AboutPrice extends StatelessWidget {
  final AssetController assetController;

  AboutPrice(this.assetController);

  @override
  Widget build(BuildContext context) {
    final asset = assetController.asset;
    final currency = asset.company?.currency ?? '';
    final price = assetController.getAssetPrice();
    return Column(
      children: [
        CustomDividerWidget(
          text: 'Variação do preço',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          dividerColor: Theme.of(context).hintColor,
        ),
        CustomFlexText(
          texts: ['Preço máxido (dia)', '${price.dayHigh.toMonetary(currency)}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Preço mínimo (dia)', '${price.dayLow.toMonetary(currency)}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Último preço', '${price.lastPrice.toMonetary(currency)}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Variação (dia)', '${price.variation.toPorcentage()}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Variação (mês)', '${price.monthVariation.toPorcentage()}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Variação (ano)', '${price.yearVariation.toPorcentage()}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Preço máxido (ano)', '${price.yearHigh.toMonetary(currency)}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
        CustomFlexText(
          texts: ['Preço mínimo (ano)', '${price.yearLow.toMonetary(currency)}'],
          alignment: MainAxisAlignment.spaceBetween,
        ),
      ],
    );
  }
}
