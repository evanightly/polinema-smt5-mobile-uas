import 'package:client/components/dashboard_drawer_list_tile.dart';
import 'package:client/components/user_anchor_menu.dart';
import 'package:client/models/dashboard_drawer_menu.dart';
import 'package:client/providers/admin_dashboard_actions_provider.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/admin/sub_screens/admin_inventory_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_main_screen.dart';
import 'package:client/screens/admin/sub_screens/admin_management_screen.dart';
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
        icon: Icons.supervised_user_circle,
        page: AdminManagementScreen(),
      ),
      'Inventory': const DashboardDrawerMenu(
        title: 'Inventory',
        icon: Icons.inventory,
        page: AdminInventoryScreen(),
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
    ref.read(authProvider.notifier).logout();
  }

  void _setSelectedIndex(String page) {
    final dashboardActions = ref.watch(adminDashboardActionsProvider.notifier);

    setState(() {
      _selectedPage = page;
    });

    // Close drawer after selecting menu
    Navigator.pop(context);

    // Reset dashboard actions to handle persisting actions bug
    dashboardActions.reset();
  }

  Widget? get _dashboardContent {
    return _drawerMenu[DashboardDrawerMenuPosition.top]?[_selectedPage]?.page ??
        _drawerMenu[DashboardDrawerMenuPosition.bottom]?[_selectedPage]?.page;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final loggedUser = ref.read(authProvider.notifier);
      loggedUser.redirectIfNotLogged(context);

      final dashboardActionsNotifier =
          ref.watch(adminDashboardActionsProvider.notifier);
      dashboardActionsNotifier.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = ref.read(authProvider);
    final dashboardActions = ref.watch(adminDashboardActionsProvider);

    Widget content = const SizedBox.shrink();

    if (loggedUser != null) {
      content = Scaffold(
        appBar: AppBar(actions: dashboardActions),
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
                            backgroundImage: AssetImage(loggedUser.image!),
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
                                const UserAnchorMenu(
                                  icon: Icon(Icons.arrow_drop_down),
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
                      DashboardDrawerListTile(
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
                      DashboardDrawerListTile(
                        isSelected: _selectedPage == page.key,
                        icon: page.value.icon,
                        title: page.value.title,
                        onTap: () {
                          page.value.onTap ?? _setSelectedIndex(page.key);
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
