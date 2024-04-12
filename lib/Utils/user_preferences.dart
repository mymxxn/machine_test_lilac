import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? preferences;
  static const _keyIsLoggedIn = 'IsLoggedIn';
  static const _keyPhoneNumber = 'phoneNumber';
  static const _keyIsDark = 'isDark';
  static Future init() async =>
      preferences = await SharedPreferences.getInstance();
  static Future setIsLoggedIn(bool IsLoggedIn) async =>
      preferences!.setBool(_keyIsLoggedIn, IsLoggedIn);
  static bool? getIsLoggedIn() => preferences!.getBool(_keyIsLoggedIn);
  static Future setPhoneNumber(int phoneNumber) async =>
      preferences!.setInt(_keyPhoneNumber, phoneNumber);
  static int? getPhoneNumber() => preferences!.getInt(_keyPhoneNumber);
  static Future setIsDark(bool IsDark) async =>
      preferences!.setBool(_keyIsDark, IsDark);
  static bool? getIsDark() => preferences!.getBool(_keyIsDark);
}
