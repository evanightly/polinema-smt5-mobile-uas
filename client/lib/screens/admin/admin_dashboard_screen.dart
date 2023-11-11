import 'package:client/components/admin_anchor_menu.dart';
import 'package:client/components/admin_dashboard_drawer_list_tile.dart';
import 'package:client/models/dashboard_drawer_menu.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/screens/admin/sub_screens/admin_car_body_type_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_car_brand_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_car_fuel_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_car_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_main_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_management_screen.dart';
import 'package:client/screens/admin/sub_screens/user_management_screen.dart';
import 'package:client/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String _selectedPage = 'Dashboard';
  late final Map<DashboardDrawerMenuPosition, Map<String, DashboardDrawerMenu>>
      _drawerMenu = {
    DashboardDrawerMenuPosition.top: {
      'Dashboard': const DashboardDrawerMenu(
        title: 'Dashboard',
        icon: Icons.dashboard,
        page: AdminMainScreen(),
      ),
      'Admin Management': const DashboardDrawerMenu(
        title: 'Admin Management',
        icon: Icons.supervisor_account,
        page: AdminManagementScreen(),
      ),
      'User Management': const DashboardDrawerMenu(
        title: 'User Management',
        icon: Icons.people,
        page: UserManagementScreen(),
      ),
      'Car': const DashboardDrawerMenu(
        title: 'Car',
        icon: Icons.directions_car,
        page: AdminCarScreen(),
      ),
      'CarFuel': const DashboardDrawerMenu(
        title: 'Car Fuel',
        icon: Icons.local_gas_station,
        page: AdminCarFuelScreen(),
      ),
      'CarBrand': const DashboardDrawerMenu(
        title: 'Car Brand',
        icon: Icons.branding_watermark,
        page: AdminCarBrandScreen(),
      ),
      'CarBodyType': const DashboardDrawerMenu(
        title: 'Car Body Type',
        icon: Icons.directions_car_filled,
        page: AdminCarBodyTypeScreen(),
      ),
      'Transactions': const DashboardDrawerMenu(
        title: 'Transactions',
        icon: Icons.attach_money,
        // page: AdminInventoryScreen(),
      ),
    },
    DashboardDrawerMenuPosition.bottom: {
      'Settings': const DashboardDrawerMenu(
        icon: Icons.settings,
        title: 'Settings',
        page: SettingsScreen(),
      ),
      'Logout': DashboardDrawerMenu(
        icon: Icons.logout,
        title: 'Logout',
        onTap: logout,
      )
    }
  };

  void logout() {
    ref.read(adminAuthProvider.notifier).logout(context);
  }

  void _setSelectedIndex(String page) {
    final loggedUser = ref.read(adminAuthProvider.notifier);

    final dashboardActions = ref.watch(adminDashboardActionsProvider.notifier);

    setState(() {
      _selectedPage = page;
    });

    // Close drawer after selecting menu
    Navigator.pop(context);

    // Reset dashboard actions to handle persisting actions bug
    dashboardActions.reset(loggedUser);
  }

  Widget? get _dashboardContent {
    return _drawerMenu[DashboardDrawerMenuPosition.top]?[_selectedPage]?.page ??
        _drawerMenu[DashboardDrawerMenuPosition.bottom]?[_selectedPage]?.page;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final loggedUser = ref.read(adminAuthProvider.notifier);
      loggedUser.redirectIfNotLogged(context);

      final dashboardActionsNotifier =
          ref.watch(adminDashboardActionsProvider.notifier);
      dashboardActionsNotifier.reset(loggedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = ref.read(adminAuthProvider);
    final dashboardActions = ref.watch(adminDashboardActionsProvider);

    Widget content = const SizedBox.shrink();

    if (loggedUser != null) {
      content = Scaffold(
        appBar: AppBar(title: Text(_selectedPage), actions: dashboardActions),
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(loggedUser.imageUrl),
                            radius: 28,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            loggedUser.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loggedUser.email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                const AdminAnchorMenu(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    for (var page
                        in _drawerMenu[DashboardDrawerMenuPosition.top]!
                            .entries)
                      AdminDashboardDrawerListTile(
                        isSelected: _selectedPage == page.key,
                        icon: page.value.icon,
                        title: page.value.title,
                        onTap: () {
                          page.value.onTap ?? _setSelectedIndex(page.key);
                        },
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: Column(
                  children: [
                    const Divider(),
                    for (var page
                        in _drawerMenu[DashboardDrawerMenuPosition.bottom]!
                            .entries)
                      AdminDashboardDrawerListTile(
                        isSelected: _selectedPage == page.key,
                        icon: page.value.icon,
                        title: page.value.title,
                        onTap: () {
                          if (page.value.onTap != null) {
                            page.value.onTap!();
                          } else {
                            _setSelectedIndex(page.key);
                          }
                        },
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: _dashboardContent,
      );
    }
    return content;
  }
}
