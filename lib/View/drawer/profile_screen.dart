import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:machine_test_lilac/Controller/profile_controller.dart';
import 'package:machine_test_lilac/Utils/constants.dart';
import 'package:machine_test_lilac/Utils/snackbar_services.dart';
import 'package:machine_test_lilac/View/components.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.imageFile.value.path != ''
                          ? FileImage(controller.imageFile.value)
                          : null,
                      child: controller.imageFile.value.path == ''
                          ? Icon(Icons.add_a_photo, size: 50)
                          : null,
                    )),
              ),
              SizedBox(height: 10),
              Components.commonTextfield(
                  txt: "Name",
                  controller: controller.nameController.value,
                  inputtype: TextInputType.name,
                  onChanged: (val) {}),
              SizedBox(height: 10),
              Components.commonTextfield(
                  txt: "Email",
                  controller: controller.emailController.value,
                  inputtype: TextInputType.emailAddress),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: Obx(() => AbsorbPointer(
                      child: Components.commonTextfield(
                          txt: "Date of Birth",
                          controller: controller.dob.value == ''
                              ? TextEditingController()
                              : TextEditingController(
                                  text: DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(controller.dob.value)
                                          .toLocal())),
                          inputtype: TextInputType.datetime,
                          readOnly: true),
                    )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => ElevatedButton(
              onPressed: () {
                if (controller.nameController.value.text.isNotEmpty ||
                    controller.emailController.value.text.isNotEmpty) {
                  controller.updateProfile();
                } else {
                  SnackBarServices.errorSnackBar("Please fill the data");
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  fixedSize: Size(
                    size.width,
                    40,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.5,
                      ),
                    )
                  : const Text(
                      'Update Profile',
                      style: TextStyle(color: Colors.white),
                    ),
            )),
      ),
    );
  }
}
