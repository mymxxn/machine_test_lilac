import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_lilac/Controller/profile_controller.dart';
import 'package:machine_test_lilac/Controller/theme_controller.dart';
import 'package:machine_test_lilac/Utils/router.dart';
import 'package:machine_test_lilac/Utils/user_preferences.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  final ThemeController _themeController = Get.put(ThemeController());
  final profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Obx(() => CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        profileController.imageFile.value.path != ''
                            ? FileImage(profileController.imageFile.value)
                            : null,
                    child: profileController.imageFile.value.path == ''
                        ? Icon(Icons.add_a_photo, size: 15)
                        : null,
                  )),
              SizedBox(
                width: 10,
              ),
              Obx(() => Text(
                    profileController.nameController.value.text.isNotEmpty
                        ? "${profileController.nameController.value.text}"
                        : 'Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ))
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          ListTile(
            title: Text("Profile"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Get.toNamed(RouteManager.profile),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text("Dark mode"),
            trailing: Obx(() => SizedBox(
                  width: 40,
                  child: SwitchListTile(
                    value: _themeController.isDarkTheme.value,
                    onChanged: (value) => _themeController.toggleTheme(),
                  ),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              "Logout",
            ),
            onTap: () {
              UserPreferences.setPhoneNumber(0);
              UserPreferences.setIsDark(false);
              UserPreferences.setIsLoggedIn(false);
              Get.offAllNamed(RouteManager.login);
            },
          )
        ],
      ),
    );
  }
}
