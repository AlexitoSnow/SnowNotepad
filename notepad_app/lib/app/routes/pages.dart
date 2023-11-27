import 'package:get/get.dart';
import '../modules/login/login_page.dart';
import '../modules/register/register_page.dart';
import '../modules/settings/settings_page.dart';
import '../modules/splash/splash_page.dart';
import 'routes.dart';

abstract class Pages {
  static List<GetPage<dynamic>> pages = [
    GetPage(name: Routes.SETTINGS, page: () => const Settings()),
    GetPage(name: Routes.LOGIN, page: () => Login()),
    GetPage(name: Routes.REGISTER, page: () => Register()),
    GetPage(name: Routes.SPLASH, page: () => const Splash()),
  ];
}
