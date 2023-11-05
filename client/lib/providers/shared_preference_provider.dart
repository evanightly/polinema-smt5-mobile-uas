import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProviderNotifier
    extends AsyncNotifier<SharedPreferences> {
  late SharedPreferences prefs;

  void init(SharedPreferences preference) => prefs = preference;

  @override
  Future<SharedPreferences> build() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}

final sharedPreferenceProvider =
    AsyncNotifierProvider<SharedPreferencesProviderNotifier, SharedPreferences>(
        SharedPreferencesProviderNotifier.new);
