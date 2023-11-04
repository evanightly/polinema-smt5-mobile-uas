import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAnchorMenu extends ConsumerWidget {
  const UserAnchorMenu({required this.icon, super.key});
  final Widget icon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    navigateToUserProfile() => Navigator.pushNamed(context, '/profile');

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: navigateToUserProfile,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('Profile'),
          ),
        ),
        MenuItemButton(
          // onPressed: authController.logout,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text('Logout'),
          ),
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
