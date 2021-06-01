import 'package:get/route_manager.dart';
import 'package:king_investor/presentation/pages/asset/asset_page.dart';
import 'package:king_investor/presentation/pages/home/home_page.dart';
import 'package:king_investor/presentation/pages/login/login_page.dart';
import 'package:king_investor/presentation/pages/search/search_page.dart';
import 'package:king_investor/presentation/pages/sign_up/sign_up_page.dart';
import 'package:king_investor/presentation/pages/splash/splash_page.dart';
import 'package:king_investor/presentation/pages/user/user_page.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const home = '/';
  static const login = '/login';
  static const signUp = '/signUp';
  static const search = '/search';
  static const asset = '/asset';
  static const user = '/user';

  static List<GetPage<dynamic>>? getAll() {
    return [
      GetPage(name: splash, page: () => SplashPage(), transition: Transition.zoom, transitionDuration: _time(800)),
      GetPage(name: home, page: () => HomePage(), transition: Transition.zoom, transitionDuration: _time(800)),
      GetPage(name: search, page: () => SearchPage(), transition: Transition.zoom, transitionDuration: _time(400)),
      GetPage(name: asset, page: () => AssetPage(), transition: Transition.zoom, transitionDuration: _time(400)),
      GetPage(name: user, page: () => UserPage(), transition: Transition.zoom, transitionDuration: _time(400)),
      GetPage(name: login, page: () => LoginPage(), transition: Transition.rightToLeftWithFade),
      GetPage(name: signUp, page: () => SignUpPage(), transition: Transition.rightToLeftWithFade),
    ];
  }

  static Duration _time(int duration) => Duration(milliseconds: duration);
}
