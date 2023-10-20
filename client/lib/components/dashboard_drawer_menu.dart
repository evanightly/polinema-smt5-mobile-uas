import 'package:client/components/dashboard_drawer_list_tile.dart';
import 'package:client/components/user_anchor_menu.dart';
import 'package:client/controllers/auth_controller.dart';
import 'package:client/controllers/dashboard_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardDrawerMenu extends StatelessWidget {
  const DashboardDrawerMenu({super.key});

  static AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final DashboardScreenController dashboardScreenController = Get.find();

    void changePage(int pageIndex) {
      dashboardScreenController.selectedPageIndex = pageIndex;
      Get.back();
    }

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const _DrawerHeader(),
                for (final (index, drawerItem) in drawerItems.indexed)
                  if (index <
                      drawerItems.length -
                          dashboardScreenController
                              .bottomDrawerItemStartingIndex)
                    Obx(
                      () => DashboardDrawerListTile(
                        icon: drawerItem.icon,
                        title: drawerItem.title,
                        isSelected:
                            dashboardScreenController.selectedPageIndex ==
                                index,
                        onTap: () => changePage(index),
                      ),
                    )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: Column(
              children: [
                const Divider(),
                for (final (index, drawerItem) in drawerItems.indexed)
                  if (index >=
                      drawerItems.length -
                          dashboardScreenController
                              .bottomDrawerItemStartingIndex)
                    Obx(
                      () => DashboardDrawerListTile(
                        key: ValueKey(drawerItem.title),
                        icon: drawerItem.icon,
                        title: drawerItem.title,
                        isSelected:
                            dashboardScreenController.selectedPageIndex ==
                                index,
                        onTap: () => drawerItem.onTap != null
                            ? drawerItem.onTap!()
                            : changePage(index),
                      ),
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(authController.loggedUser.image!),
            radius: 28,
          ),
          const SizedBox(height: 14),
          Text(
            authController.loggedUser.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  authController.loggedUser.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
