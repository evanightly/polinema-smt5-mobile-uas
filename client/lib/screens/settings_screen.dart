import 'package:client/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  final settingsController = Get.put(SettingsController());

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SwitchListTile.adaptive(
            title: const Text('Dark Mode'),
            value: settingsController.isDarkMode,
            // onChanged: (bool switchTo) =>
            //     settingsController.isDarkMode = switchTo,
            onChanged: (bool switchTo) =>
                settingsController.isDarkMode = switchTo,
          ),
        ],
      ),
    );
  }
}
