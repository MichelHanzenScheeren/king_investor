import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/pages/home/widgets/asset_operation.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class AssetsOptions extends StatelessWidget {
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<HomeController>(
      builder: (homeController) {
        if (appDataController.isLoadingSomething) return Container();
        bool showOption = appDataController.assets.length > 0;
        return SpeedDial(
          backgroundColor: theme.primaryColor,
          icon: Icons.add,
          activeIcon: Icons.arrow_downward,
          iconTheme: IconThemeData(color: theme.hintColor),
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            _getFloatButton(
              'Novo ativo',
              Icons.store,
              theme,
              onTap: () async {
                await Get.toNamed(AppRoutes.search);
                appDataController.loadAllPrices();
              },
            ),
            _getFloatButton(
              'Dividendo/JCP',
              Icons.attach_money,
              theme,
              show: showOption,
              onTap: () => _incomeOperation(homeController),
            ),
            _getFloatButton(
              'Compra',
              Icons.exposure_plus_1,
              theme,
              show: showOption,
              onTap: () => _buyOperation(homeController),
            ),
            _getFloatButton(
              'Venda',
              Icons.exposure_minus_1_outlined,
              theme,
              show: showOption,
              onTap: () => _saleOperation(homeController),
            ),
          ],
          // TODO
        );
      },
    );
  }

  SpeedDialChild _getFloatButton(String label, IconData icon, ThemeData theme, {Function onTap, bool show: true}) {
    if (!show) return SpeedDialChild(backgroundColor: Colors.transparent, elevation: 0, onTap: null);
    return SpeedDialChild(
      child: Icon(icon, color: theme.hintColor),
      label: label,
      backgroundColor: theme.primaryColor,
      labelBackgroundColor: theme.primaryColor,
      labelStyle: TextStyle(color: theme.hintColor),
      onTap: onTap,
    );
  }

  void _buyOperation(HomeController homeController) {
    Get.bottomSheet(
      AssetOperation(dividerOperation: 'compra', onSave: homeController.saveAssetBuy),
      isDismissible: false,
    );
  }

  void _saleOperation(HomeController homeController) {
    Get.bottomSheet(
      AssetOperation(dividerOperation: 'venda', onSave: homeController.saveAssetSale),
      isDismissible: false,
    );
  }

  void _incomeOperation(HomeController homeController) {
    Get.bottomSheet(AssetOperation(
      dividerOperation: 'receita',
      onSave: homeController.saveAssetIncome,
      isIncomeOperation: true,
    ));
  }
}
