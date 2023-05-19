import 'package:get/get.dart';
import 'package:king_investor/presentation/pages/asset/asset_page.dart';
import 'package:king_investor/presentation/pages/home/home_page.dart';
import 'package:king_investor/presentation/pages/login/login_page.dart';
import 'package:king_investor/presentation/pages/search/search_page.dart';
import 'package:king_investor/presentation/pages/sign_up/sign_up_page.dart';
import 'package:king_investor/presentation/pages/splash/splash_page.dart';
import 'package:king_investor/presentation/pages/user/user_page.dart';
import 'package:king_investor/presentation/static/app_routes.dart';

List<GetPage<dynamic>> appPages() {
  return [
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
    GetPage(
        name: AppRoutes.search,
        page: () => SearchPage(),
        transition: Transition.zoom,
        transitionDuration: Duration(milliseconds: 400)),
    GetPage(
        name: AppRoutes.asset,
        page: () => AssetPage(),
        transition: Transition.zoom,
        transitionDuration: Duration(milliseconds: 400)),
    GetPage(
        name: AppRoutes.user,
        page: () => UserPage(),
        transition: Transition.zoom,
        transitionDuration: Duration(milliseconds: 400)),
    GetPage(
        name: AppRoutes.login,
        page: () => LoginPage(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: AppRoutes.signUp,
        page: () => SignUpPage(),
        transition: Transition.rightToLeftWithFade),
  ];
}
