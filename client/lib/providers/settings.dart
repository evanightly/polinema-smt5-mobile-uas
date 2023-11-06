import 'package:client/models/dashboard_settings.dart';
import 'package:client/providers/shared_preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  final darkModeKey = 'darkMode';

  late final SharedPreferences prefs;

  void toggleDarkMode(bool changeTo) {
    state = DashboardSettings(darkMode: changeTo);
    prefs.setBool(darkModeKey, state.darkMode);
  }

  @override
  DashboardSettings build() {
    prefs = ref.read(sharedPreferenceProvider.notifier).prefs;

    final isDarkMode = prefs.getBool(darkModeKey) ?? false;

    if (isDarkMode == true) {
      state = DashboardSettings(darkMode: isDarkMode);
    } else {
      state = const DashboardSettings(darkMode: false);
      prefs.setBool(darkModeKey, state.darkMode);
    }

    return DashboardSettings(darkMode: state.darkMode);
  }
}
