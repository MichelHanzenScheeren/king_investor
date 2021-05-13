import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class AssetsOptions extends StatelessWidget {
  final AppDataController appDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<HomeController>(
      builder: (homeController) {
        if (appDataController.isLoadingSomething) return Container();
        bool showAssetsOptions = appDataController.assets.length > 0;
        return SpeedDial(
          backgroundColor: theme.primaryColor,
          icon: Icons.add,
          activeIcon: Icons.arrow_downward,
          iconTheme: IconThemeData(color: theme.hintColor),
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            _getFloatButton('Novo ativo', Icons.store, theme, onTap: () => Get.toNamed(AppRoutes.search)),
            _getFloatButton('Dividendo/JCP', Icons.attach_money, theme, show: showAssetsOptions),
            _getFloatButton('Compra', Icons.exposure_plus_1, theme, show: showAssetsOptions),
            _getFloatButton('Venda', Icons.exposure_minus_1_outlined, theme, show: showAssetsOptions),
          ],
        );
      },
    );
  }

  SpeedDialChild _getFloatButton(String label, IconData icon, ThemeData theme, {Function onTap, bool show}) {
    if (!show) return SpeedDialChild();
    return SpeedDialChild(
      child: Icon(icon, color: theme.hintColor),
      label: label,
      backgroundColor: theme.primaryColor,
      labelBackgroundColor: theme.primaryColor,
      labelStyle: TextStyle(color: theme.hintColor),
      onTap: onTap,
    );
  }
}
