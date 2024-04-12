import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Utils/constants.dart';
import 'package:machine_test_lilac/Utils/router.dart';
import 'package:machine_test_lilac/Utils/snackbar_services.dart';
import 'package:machine_test_lilac/Utils/user_preferences.dart';

class LoginController extends GetxController {
  var phoneController = TextEditingController().obs;
  var isLoading = false.obs;

  verifyPhoneNumber(BuildContext context) async {
    isLoading.value = true;
    update();
    String phoneNumber = '+91${phoneController.value.text.trim()}';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Automatic verification (e.g., instant validation)
        // signInWithPhoneAuthCredential(credential);
        isLoading.value = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false;
        update();
        SnackBarServices.errorSnackBar(e.message.toString());
        // Verification failed
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading.value = false;
        update();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "PIN",
                          style: TextStyle(
                              color: Constants.mutedColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Constants.mutedColor,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Constants.lightGrey,
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    signInWithPhoneNumber(
                        smsCode: verificationCode,
                        verificationId: verificationId);
                  }, // end onSubmit
                ),
              ),
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        isLoading.value = false;
        update();
        // Called when auto-retrieval timeout
      },
    );
  }

  void signInWithPhoneNumber(
      {required String verificationId, required String smsCode}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      UserPreferences.setIsLoggedIn(true);
      UserPreferences.setPhoneNumber(int.parse(phoneController.value.text));
      Get.toNamed(RouteManager.home);
    } catch (e) {
      print(e.toString());
    }
  }
}
