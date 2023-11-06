import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference.g.dart';

@Riverpod(keepAlive: true)
class SharedPreference extends _$SharedPreference {
  late SharedPreferences prefs;

  void init(SharedPreferences preference) => prefs = preference;

  @override
  Future<SharedPreferences> build() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
