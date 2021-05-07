import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/home_controller.dart';
import 'package:king_investor/presentation/static/app_images.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomeController controller;

  HomeController _getController() {
    if (controller == null) controller = HomeController(TabController(vsync: this, length: 3));
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: _getController(),
      builder: (controller) {
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
              IconButton(
                icon: Icon(Icons.settings_outlined, color: theme.hintColor),
                onPressed: () => Get.toNamed(AppRoutes.login),
              ),
            ],
            bottom: TabBar(
              controller: controller.tabController,
              tabs: [
                Tab(icon: Icon(Icons.perm_camera_mic_rounded)),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.dashboard))
              ],
            ),
          ),
          body: TabBarView(
            controller: controller.tabController,
            children: [
              Container(color: Colors.red),
              Container(color: Colors.green),
              Container(color: Colors.purple),
            ],
          ),
        );
      },
    );
  }
}
