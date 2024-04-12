import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Controller/splash_controller.dart';
import 'package:machine_test_lilac/Utils/constants.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Constants.primaryColor,
          child: Center(
              child: Text(
            "Welcome",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ))),
    );
  }
}
