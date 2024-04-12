import 'package:get/get.dart';
import 'package:machine_test_lilac/View/drawer/profile_screen.dart';
import 'package:machine_test_lilac/View/home_screen.dart';
import 'package:machine_test_lilac/View/login_screen.dart';
import 'package:machine_test_lilac/View/splash_screen.dart';

class RouteManager {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  List<GetPage> route = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => SignInScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
  ];
}
