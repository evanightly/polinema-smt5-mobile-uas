import 'package:client/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsProviderNotifier extends StateNotifier<Settings> {
  SettingsProviderNotifier() : super(const Settings(darkMode: false));

  void toggleDarkMode(bool changeTo) {
    state = Settings(darkMode: changeTo);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsProviderNotifier, Settings>(
  (ref) => SettingsProviderNotifier(),
);
