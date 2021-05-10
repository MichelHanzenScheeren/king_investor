import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/pages/wallet/wallet_page.dart';
import 'package:king_investor/presentation/static/app_images.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class HomePage extends StatelessWidget {
  final HomeController globalHomeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: globalHomeController,
      builder: (homeController) {
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            leading: Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 0, 2),
              child: Image(
                image: AssetImage(AppImages.transparentLogo),
                fit: BoxFit.fill,
              ),
            ),
            title: Text('KING INVESTOR', style: TextStyle(color: theme.hintColor)),
            centerTitle: false,
            actions: [
              IconButton(icon: Icon(Icons.visibility, color: theme.hintColor), onPressed: () {}),
              IconButton(icon: Icon(Icons.settings, color: theme.hintColor), onPressed: () {}),
            ],
          ),
          body: PageView(
            controller: homeController.pageController,
            onPageChanged: (value) => homeController.setCurrentPage(value),
            children: [
              WalletPage(),
              Container(color: Colors.green),
              Container(color: Colors.purple),
              Container(color: Colors.yellow),
            ],
          ),
          bottomNavigationBar: Obx(() {
            return BottomNavigationBar(
              currentIndex: homeController.currentPage,
              onTap: (value) => homeController.jumpToPage(value),
              backgroundColor: theme.primaryColor,
              selectedItemColor: theme.hintColor,
              unselectedItemColor: theme.hintColor.withAlpha(150),
              items: [
                _getIcon("Carteira", Icons.account_balance_wallet, theme.primaryColor),
                _getIcon("Evolução", Icons.show_chart, theme.primaryColor),
                _getIcon("Distribuição", Icons.pie_chart, theme.primaryColor),
                _getIcon("Rebalancear", Icons.account_balance, theme.primaryColor),
              ],
            );
          }),
          floatingActionButton: SpeedDial(
            backgroundColor: theme.primaryColor,
            icon: Icons.add,
            activeIcon: Icons.arrow_downward,
            iconTheme: IconThemeData(color: theme.hintColor),
            overlayOpacity: 0.4,
            overlayColor: Colors.black,
            children: [
              _getFloatButton('Novo ativo', Icons.store, theme, onTap: () => Get.toNamed(AppRoutes.search)),
              _getFloatButton('Dividendo/JCP', Icons.attach_money, theme),
              _getFloatButton('Compra', Icons.exposure_plus_1, theme),
              _getFloatButton('Venda', Icons.exposure_minus_1_outlined, theme),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _getIcon(String label, IconData icon, Color color) {
    return BottomNavigationBarItem(label: label, icon: Icon(icon), backgroundColor: color);
  }

  SpeedDialChild _getFloatButton(String label, IconData icon, ThemeData theme, {Function onTap}) {
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
