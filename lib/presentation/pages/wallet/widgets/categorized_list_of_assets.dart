import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/presentation/controllers/load_data_controller.dart';
import 'package:king_investor/presentation/controllers/wallet_controller.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/empty_assets.dart';
import 'package:king_investor/presentation/pages/wallet/widgets/load_assets_failed.dart';
import 'package:king_investor/presentation/widgets/custom_card_widget.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class CategorizedListOfAssets extends StatelessWidget {
  final LoadDataController loadController;
  final WalletController walletController;

  CategorizedListOfAssets({this.loadController, this.walletController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      if (loadController.categoriesLoad || loadController.assetsLoad) return _awaiting(context);
      if (!walletController.isValidData) return LoadAssetsFailed();
      if (walletController.isEmptyData) return EmptyAssets();
      final validCategories = walletController.validCategories();
      return ListView.builder(
        shrinkWrap: true,
        itemCount: validCategories.length,
        itemBuilder: (context, index) {
          final categoryAssets = walletController.getCategoryAssets(validCategories[index]);
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: theme.cardColor,
            ),
            child: Theme(
              data: theme.copyWith(
                unselectedWidgetColor: theme.primaryColorLight,
                textTheme: TextTheme(subtitle1: TextStyle(fontSize: 20, color: theme.primaryColorLight)),
                accentColor: theme.hintColor,
              ),
              child: ExpansionTile(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                title: Text(validCategories[index]?.name ?? '*****'),
                childrenPadding: EdgeInsets.zero,
                children: List<Widget>.generate(categoryAssets.length, (index) {
                  final company = categoryAssets[index].company;
                  return Column(
                    children: <Widget>[
                      Divider(color: theme.primaryColorLight, height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                        dense: true,
                        isThreeLine: true,
                        title: enterpryseName(company),
                        subtitle: Text(company.name, style: TextStyle(fontSize: 14)),
                        // trailing: enterprysePrice(item, theme),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _awaiting(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomCardWidget(
      children: [
        Container(
          height: size.width * 0.9,
          alignment: Alignment.center,
          child: LoadIndicatorWidget(usePrimaryColor: false, size: 120),
        ),
      ],
    );
  }

  Widget enterpryseName(Company item) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          text: item.symbol,
          style: TextStyle(fontSize: 18),
          children: <TextSpan>[
            TextSpan(text: "     ${item.exchange} - ${item.country}", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
