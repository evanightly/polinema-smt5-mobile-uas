import 'package:client/models/settings.dart';
import 'package:client/providers/shared_preference_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const darkModeKey = 'darkMode';

class SettingsProviderNotifier extends Notifier<Settings> {
  late final SharedPreferences prefs;

  void toggleDarkMode(bool changeTo) {
    state = Settings(darkMode: changeTo);
    prefs.setBool(darkModeKey, state.darkMode);
  }

  @override
  Settings build() {
    prefs = ref.read(sharedPreferenceProvider.notifier).prefs;

    final isDarkMode = prefs.getBool(darkModeKey) ?? false;

    if (isDarkMode == true) {
      state = Settings(darkMode: isDarkMode);
    } else {
      state = const Settings(darkMode: false);
      prefs.setBool(darkModeKey, state.darkMode);
    }

    return Settings(darkMode: state.darkMode);
  }
}

final settingsProvider = NotifierProvider<SettingsProviderNotifier, Settings>(
    SettingsProviderNotifier.new);
