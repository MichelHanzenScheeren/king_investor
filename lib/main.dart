import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/dependencies_injection.dart';
import 'package:king_investor/presentation/pages/home/home_page.dart';
import 'package:king_investor/presentation/pages/login/login_page.dart';
import 'package:king_investor/presentation/pages/sign_up/sign_up_page.dart';
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
        scaffoldBackgroundColor: Color(0x212429),
        backgroundColor: Color(0x212429),
        dialogBackgroundColor: Color(0x2A2D32).withAlpha(110),
        cardColor: Color(0x2A2D32).withAlpha(110),
        canvasColor: Colors.grey[800],
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        hintColor: Colors.white,
        primaryColorLight: Colors.white.withAlpha(200),
        focusColor: Colors.grey[800],
        errorColor: Colors.red[400],
        hoverColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white.withAlpha(200),
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(
            name: AppRoutes.splash,
            page: () => SplashPage(),
            transition: Transition.zoom,
            transitionDuration: Duration(milliseconds: 800)),
        GetPage(
            name: AppRoutes.home,
            page: () => HomePage(),
            transition: Transition.zoom,
            transitionDuration: Duration(milliseconds: 800)),
        GetPage(name: AppRoutes.login, page: () => LoginPage(), transition: Transition.rightToLeftWithFade),
        GetPage(name: AppRoutes.signUp, page: () => SignUpPage(), transition: Transition.rightToLeftWithFade),
      ],
    );
  }
}
