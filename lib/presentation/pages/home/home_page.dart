import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/pages/evolution/evolution_page.dart';
import 'package:king_investor/presentation/pages/home/widgets/asset_options.dart';
import 'package:king_investor/presentation/pages/rebalance/rebalance_page.dart';
import 'package:king_investor/presentation/pages/wallet/wallet_page.dart';
import 'package:king_investor/presentation/static/app_images.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = HomeController();

  @override
  Widget build(BuildContext context) {
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
          EvolutionPage(),
          Container(color: Colors.purple),
          RebalancePage(),
        ],
      ),
      bottomNavigationBar: GetX<HomeController>(
        autoRemove: false,
        init: homeController,
        builder: (homeController) => BottomNavigationBar(
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
        ),
      ),
      floatingActionButton: AssetsOptions(),
    );
  }

  BottomNavigationBarItem _getIcon(String label, IconData icon, Color color) {
    return BottomNavigationBarItem(label: label, icon: Icon(icon), backgroundColor: color);
  }
}
