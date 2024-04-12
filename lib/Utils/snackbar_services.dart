import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarServices {
  static errorSnackBar(String message) => Get.snackbar('Warning', message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2),
      icon: Icon(Icons.error, color: Colors.white));

  static void successSnackbar(String message) {
    Get.snackbar('Success', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        icon: Icon(Icons.check, color: Colors.white));
  }

  static void infoSnackBar(String message) {
    Get.snackbar('Info', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
        icon: Icon(Icons.check, color: Colors.white));
  }
}
