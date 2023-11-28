import 'package:client/components/user_dashboard_appbar_profile.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/screens/settings_screen.dart';
import 'package:client/screens/user/sub_screens/user_main_screen.dart';
import 'package:client/screens/user/sub_screens/user_transaction_screen.dart';
import 'package:client/screens/user/widgets/cart/cart_screen.dart';
import 'package:client/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserDashboardScreen extends ConsumerStatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  ConsumerState<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class DashboardBottomMenu {
  final SalomonBottomBarItem menu;
  final Widget? page;

  const DashboardBottomMenu({required this.menu, this.page});
}

class _UserDashboardScreenState extends ConsumerState<UserDashboardScreen> {
  var _currentIndex = 0;

  final List<DashboardBottomMenu> _bottomMenu = [
    DashboardBottomMenu(
      menu: SalomonBottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text("Home"),
        selectedColor: Colors.purple,
      ),
      page: const UserMainScreen(),
    ),
    DashboardBottomMenu(
      menu: SalomonBottomBarItem(
        icon: const Icon(Icons.my_library_books_outlined),
        title: const Text("My Transactions"),
        selectedColor: Colors.orange,
      ),
      page: const UserTransactionScreen(),
    ),
    // Settings
    DashboardBottomMenu(
      menu: SalomonBottomBarItem(
        icon: const Icon(Icons.settings),
        title: const Text("Settings"),
        selectedColor: Colors.teal,
      ),
      page: const SettingsScreen(),
    ),
    DashboardBottomMenu(
      menu: SalomonBottomBarItem(
        icon: const Icon(Icons.person),
        title: const Text("Profile"),
        selectedColor: Colors.blue,
      ),
      page: const UserProfileScreen(disableBackButton: true),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userAuthProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambatucar', style: TextStyle(fontSize: 20.0)),
        automaticallyImplyLeading: false,
        actions: [
          // show cart and user profile
          if (user != null) const CartScreen(),
          const UserDashboardAppBarProfile()
        ],
      ),
      body: _bottomMenu[_currentIndex].page ??
          const Center(child: Text('No page yet')),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: _bottomMenu.map((e) => e.menu).toList(),
      ),
    );
  }
}
