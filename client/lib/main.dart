import 'package:client/config/custom_theme.dart';
import 'package:client/providers/settings.dart';
import 'package:client/providers/shared_preference.dart';
import 'package:client/screens/admin/admin_dashboard_screen.dart';
import 'package:client/screens/admin/admin_login_screen.dart';
import 'package:client/screens/admin_profile_screen.dart';
import 'package:client/screens/home_screen.dart';
import 'package:client/screens/user/user_dashboard_screen.dart';
import 'package:client/screens/user/user_login_screen.dart';
import 'package:client/screens/user/user_register_screen.dart';
import 'package:client/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'public.env');

  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(child: App(prefs)));
}

class App extends ConsumerWidget {
  final SharedPreferences prefs;
  const App(this.prefs, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(sharedPreferenceProvider.notifier).init(prefs);
    return MaterialApp(
      title: 'Mein App',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme:
          ref.watch(settingsProvider).darkMode ? darkThemeData : lightThemeData,
      routes: {
        '/': (context) => const HomeScreen(),
        '/admin/login': (context) => const AdminLoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/user/login': (context) => const UserLoginScreen(),
        '/user/register': (context) => const UserRegisterScreen(),
        '/user': (context) => const UserDashboardScreen(),
        '/admin/profile': (context) => const AdminProfileScreen(),
        '/user/profile': (context) => const UserProfileScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
