import 'package:client/config/custom_theme.dart';
import 'package:client/screens/admin/admin_dashboard_screen.dart';
import 'package:client/screens/admin/admin_login_screen.dart';
import 'package:client/screens/home_screen.dart';
import 'package:client/screens/user/user_dashboard_screen.dart';
import 'package:client/screens/user/user_login_screen.dart';
import 'package:client/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  runApp(const ProviderScope(child: App()));
}

final themeProvider = createPrefProvider<bool>(
  prefs: (_) => prefs,
  prefKey: "darkMode",
  defaultValue: false,
);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeProvider) ? darkThemeData : lightThemeData,
      routes: {
        '/': (context) => const HomeScreen(),
        '/admin/login': (context) => const AdminLoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/user/login': (context) => const UserLoginScreen(),
        '/user': (context) => const UserDashboardScreen(),
        '/profile': (context) => const UserProfileScreen(),
      },
    );
  }
}
