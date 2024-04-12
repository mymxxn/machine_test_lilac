import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Controller/login_controller.dart';
import 'package:machine_test_lilac/Utils/constants.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Constants.bgImage), fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                "Hi! Welcome back you have been missed.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextField(
                    controller: controller.phoneController.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        isCollapsed: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() => ElevatedButton(
                    onPressed: () async {
                      controller.verifyPhoneNumber(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      fixedSize: Size(size.width, 50),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator()
                        : Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          ),
                  )),
            ]),
          )),
    );
  }
}
