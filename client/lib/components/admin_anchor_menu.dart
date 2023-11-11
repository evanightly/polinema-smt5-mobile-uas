import 'package:client/providers/admin_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAnchorMenu extends ConsumerWidget {
  const AdminAnchorMenu({required this.icon, super.key});

  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    navigateToUserProfile() => Navigator.pushNamed(context, '/admin/profile');

    void logout() {
      ref.read(adminAuthProvider.notifier).logout(context);
    }

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
          onPressed: logout,
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
