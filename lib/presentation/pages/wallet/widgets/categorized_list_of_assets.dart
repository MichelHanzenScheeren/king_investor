import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/empty_assets.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/load_assets_failed.dart';
import 'package:king_investor/presentation/widgets/custom_expansion_tile_widget.dart';
import 'package:king_investor/presentation/widgets/load_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class CategorizedListOfAssets extends StatelessWidget {
  final AppDataController appDataController;
  final WalletController walletController;

  CategorizedListOfAssets({this.appDataController, this.walletController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      if (appDataController.categoriesLoad || appDataController.assetsLoad) return LoadCardWidget();
      if (!walletController.isValidData) return LoadAssetsFailed();
      if (walletController.isEmptyData) return EmptyAssets();
      final validCategories = walletController.validCategories();
      return ListView.builder(
        shrinkWrap: true,
        itemCount: validCategories.length,
        itemBuilder: (context, index) {
          final categoryAssets = walletController.getCategoryAssets(validCategories[index]);
          return CustomExpansionTileWidget(
            title: Text(validCategories[index]?.name ?? "?", style: TextStyle(fontSize: 20)),
            children: List<Widget>.generate(categoryAssets.length, (index) {
              final company = categoryAssets[index].company;
              final normalStyle = TextStyle(color: theme.primaryColorLight, fontSize: 13);
              final subtitleStyle = TextStyle(color: theme.primaryColorLight.withAlpha(220), fontSize: 14);
              final titleStyle = TextStyle(color: theme.hintColor, fontSize: 18);
              return Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                    visualDensity: VisualDensity(vertical: -1),
                    dense: true,
                    title: Container(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: RichText(
                        text: TextSpan(
                          text: company.symbol + '   ',
                          style: titleStyle,
                          children: [TextSpan(text: "${company.exchange} - ${company.country}", style: normalStyle)],
                        ),
                      ),
                    ),
                    subtitle: Text(company.name, style: subtitleStyle),
                    trailing: companyPrice(company, theme),
                  ),
                  Divider(color: theme.primaryColorLight, height: 2),
                ],
              );
            }),
          );
        },
      );
    });
  }

  Widget companyPrice(Company company, ThemeData theme) {
    return Obx(() {
      if (appDataController.pricesLoad) return LoadIndicatorWidget(size: 30, strokeWidth: 3, usePrimaryColor: false);
      final price = walletController.getPriceByTicker(company?.ticker);
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${price.lastPrice.toMonetary(company.currency)}',
            style: theme.textTheme.headline1.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorLight,
            ),
          ),
          SizedBox(height: 4),
          Text(
            price.variation.toPorcentage(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: price.variation.value > 0
                  ? theme.hoverColor
                  : (price.variation.value < 0 ? theme.errorColor : theme.primaryColorLight),
            ),
          ),
        ],
      );
    });
  }
}
