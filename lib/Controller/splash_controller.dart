import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Utils/router.dart';
import 'package:machine_test_lilac/Utils/user_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    enterApp();
  }

  enterApp() {
    bool isLoggedIn = UserPreferences.getIsLoggedIn() ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        if (isLoggedIn) {
          Get.offNamed(RouteManager.home);
          Get.changeTheme(UserPreferences.getIsDark() ?? false
              ? ThemeData.dark()
              : ThemeData.light());
        } else {
          Get.offNamed(RouteManager.login);
        }
      });
    });
  }
}
