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

    // ignore: non_constant_identifier_names, unused_local_variable
    DrawerHeader DrawerSolution1 = DrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dashboard_drawer.jpg'),
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.multiply),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 12),
            child: Text(
              'Car Inventory',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onInverseSurface
                        .withOpacity(.85),
                  ),
            ),
          )
        ],
      ),
    );

    // ignore: non_constant_identifier_names
    DrawerHeader DrawerSolution2 = DrawerHeader(
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

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerSolution2,
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
                        onTap: () => changePage(index),
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
