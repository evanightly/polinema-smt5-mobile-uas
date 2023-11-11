import 'package:client/components/admin_anchor_menu.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardAppBarProfile extends ConsumerWidget {
  const AdminDashboardAppBarProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic user = ref.watch(adminAuthProvider);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: AdminAnchorMenu(
        icon: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.imageUrl),
              radius: 20,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Colors.lightGreen, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
