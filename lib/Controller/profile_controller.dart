import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_test_lilac/Utils/snackbar_services.dart';
import 'package:machine_test_lilac/Utils/user_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  final dob = ''.obs; // Using GetX observable for DOB
  var imageFile = File('').obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch profile data when the controller is initialized
    getProfileData();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dob.value = pickedDate.toString(); // Update the observable
    }
  }

  void updateProfile() async {
    isLoading.value = true;
    try {
      // Upload image to Firebase Storage if imageFile is not null
      String? imageUrl;
      if (imageFile.value.path != '') {
        imageUrl = await fileToBase64(imageFile.value);
      }

      // Update user profile data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(UserPreferences.getPhoneNumber().toString())
          .set({
        'phone': UserPreferences.getPhoneNumber(),
        'name': nameController.value.text,
        'email': emailController.value.text,
        'dob': dob.value,
        if (imageUrl != null) 'profileImageUrl': imageUrl,
      });

      // Show success message using GetX snackbar
      SnackBarServices.successSnackbar('Your profile has been updated.');
    } catch (e) {
      // Show error message using GetX snackbar
      SnackBarServices.errorSnackBar('Failed to update profile.');
      print('Error updating profile: $e');
    } finally {
      // Reset isLoading value
      isLoading.value = false;
    }
  }

  Future<String> fileToBase64(File file) async {
    // Read file as bytes
    Uint8List fileBytes = await file.readAsBytes();

    // Encode bytes to Base64
    String base64String = base64Encode(fileBytes);

    return base64String;
  }

  Future<void> getProfileData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(UserPreferences.getPhoneNumber().toString())
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        nameController.value.text = data['name'];
        emailController.value.text = data['email'];
        dob.value = data['dob'];

        // Decode and save profile image to temporary file
        File? profileImageFile =
            await base64ToFile(data['profileImageUrl'], 'profile_image.jpg');

        // Update imageFile observable
        if (profileImageFile != null) {
          imageFile.value = profileImageFile;
        }

        update(); // Update GetX state
      }
    } catch (e) {
      print('Error getting profile data: $e');
    }
  }

  Future<File?> base64ToFile(String base64String, String fileName) async {
    try {
      // Decode base64 string
      Uint8List bytes = base64.decode(base64String);

      // Get the temporary directory path using path_provider package
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Save the decoded bytes to a file
      File file = File('$tempPath/$fileName');
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print('Error converting base64 to file: $e');
      return null;
    }
  }
}
