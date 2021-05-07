import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/dependencies_injection.dart';
import 'package:king_investor/presentation/pages/home/home_page.dart';
import 'package:king_investor/presentation/pages/login/login_page.dart';
import 'package:king_investor/presentation/pages/splash/splash_page.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependenciesInjection.init(Environments.development);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'King Investor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color.fromRGBO(15, 15, 16, 1),
        backgroundColor: Color.fromRGBO(15, 15, 16, 1),
        dialogBackgroundColor: Color.fromRGBO(30, 30, 30, 1),
        canvasColor: Colors.grey[800],
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        hintColor: Colors.white,
        focusColor: Colors.grey[800],
        errorColor: Colors.red[400],
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => SplashPage()),
        GetPage(name: AppRoutes.home, page: () => HomePage()),
        GetPage(name: AppRoutes.login, page: () => LoginPage()),
      ],
    );
  }
}
