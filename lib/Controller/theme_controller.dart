import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Utils/user_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkTheme = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = UserPreferences.getIsDark() ?? false;
  }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value; // Toggle theme
    UserPreferences.setIsDark(isDarkTheme.value);
    Get.changeTheme(isDarkTheme.value ? ThemeData.dark() : ThemeData.light());
  }
}
