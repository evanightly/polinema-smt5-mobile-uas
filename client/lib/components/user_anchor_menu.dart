import 'package:client/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAnchorMenu extends StatelessWidget {
  const UserAnchorMenu({required this.icon, super.key});

  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('Profile'),
          ),
          onPressed: () => Get.to(const UserProfileScreen()),
        ),
        MenuItemButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('Logout'),
          ),
          onPressed: () {},
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: icon,
        );
      },
    );
  }
}
