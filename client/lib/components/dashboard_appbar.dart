import 'package:client/controllers/auth_controller.dart';
import 'package:client/controllers/dashboard_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  DashboardAppBar({required this.appBar, required this.actions, super.key});

  final dashboardScreenController = Get.put(DashboardScreenController());
  final AuthController authController = Get.find();

  final AppBar appBar;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Obx(
        () => Text(
            drawerItems[dashboardScreenController.selectedPageIndex].title),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
