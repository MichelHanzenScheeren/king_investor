import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/pages/distribution/distribution_page.dart';
import 'package:king_investor/presentation/pages/evolution/evolution_page.dart';
import 'package:king_investor/presentation/pages/home/widgets/asset_options.dart';
import 'package:king_investor/presentation/pages/rebalance/rebalance_page.dart';
import 'package:king_investor/presentation/pages/wallet/wallet_page.dart';
import 'package:king_investor/presentation/static/app_images.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class HomePage extends StatelessWidget {
  final PageController pageController = PageController(initialPage: 0);
  final ScrollController scrollController = ScrollController();
  final HomeController homeController = HomeController();

  HomePage() {
    homeController.registerControllers(pageController, scrollController);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.fromLTRB(4, 2, 0, 2),
          child: Image(image: AssetImage(AppImages.transparentLogo), fit: BoxFit.fill),
        ),
        title: Text('KING INVESTOR ', style: TextStyle(color: theme.hintColor)),
        centerTitle: false,
        actions: [
          IconButton(icon: Icon(Icons.settings, color: theme.hintColor), onPressed: () => Get.toNamed(AppRoutes.user)),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => homeController.setCurrentPage(value),
        children: [
          ListView(controller: scrollController, children: [WalletPage()]),
          ListView(controller: scrollController, children: [EvolutionPage()]),
          ListView(controller: scrollController, children: [DistributionPage()]),
          ListView(controller: scrollController, children: [RebalancePage()]),
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
            _getIcon("Rebalancear ", Icons.account_balance, theme.primaryColor),
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
