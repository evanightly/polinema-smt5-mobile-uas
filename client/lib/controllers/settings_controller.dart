import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const initialDarkModeValue = false;

class SettingsController extends GetxController {
  final _darkModeKey = 'darkMode';
  final _isDarkMode = RxBool(initialDarkModeValue);
  late GetStorage box;

  bool get isDarkMode => _isDarkMode.value;
  bool get storageDarkMode => box.read(_darkModeKey);

  set isDarkMode(bool switchTo) {
    _isDarkMode.value = switchTo;
    box.write(_darkModeKey, switchTo);
    _isDarkMode.value = storageDarkMode;
    applyTheme();
  }

  void applyTheme() {
    final theme = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(theme);
  }

  @override
  void onReady() {
    super.onReady();
    box = GetStorage();

    if (!storageDarkMode) {
      box.write(_darkModeKey, initialDarkModeValue);
    }

    isDarkMode = storageDarkMode;
  }
}
