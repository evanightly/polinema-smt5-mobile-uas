import 'package:client/components/dashboard_appbar_user.dart';
import 'package:client/controllers/auth_controller.dart';
import 'package:client/models/dashboard_drawer_item.dart';
import 'package:client/screens/admin_screen.dart';
import 'package:client/screens/dashboard_screen.dart';
import 'package:client/screens/inventory_screen.dart';
import 'package:client/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AuthController authController = Get.find();

final drawerItems = [
  const DashboardDrawerItem(
    title: 'Dashboard',
    icon: Icons.dashboard,
    component: DashboardScreen(),
  ),
  const DashboardDrawerItem(
      title: 'Admin Management',
      icon: Icons.admin_panel_settings,
      component: AdminScreen()),
  const DashboardDrawerItem(
    title: 'Inventory',
    icon: Icons.inventory_2_rounded,
    component: InventoryScreen(),
  ),
  const DashboardDrawerItem(
    title: 'Settings',
    icon: Icons.settings,
    component: SettingsScreen(),
  ),
  DashboardDrawerItem(
    title: 'Logout',
    icon: Icons.logout,
    onTap: authController.logout,
  ),
];

class DashboardScreenController extends GetxController {
  final _selectedPageIndex = 0.obs;
  final bottomDrawerItemStartingIndex =
      2; // item <= drawerItems.length - 2 (Push Settings and Logout drawer item to bottom), used in dashboard_drawer_menu

  int get selectedPageIndex => _selectedPageIndex.value;
  set selectedPageIndex(int pageIndex) {
    _selectedPageIndex.value = pageIndex;

    // Set default scaffold Actions when screen change
    _scaffoldInit();
  }

  final _scaffoldActions = <Widget>[].obs;

  List<Widget> get scaffoldActions => _scaffoldActions;
  set scaffoldActions(List<Widget> widgets) => _scaffoldActions.value = widgets;

  void _scaffoldInit() => _scaffoldActions.value = [const DashboardAppBarUser()];
}
