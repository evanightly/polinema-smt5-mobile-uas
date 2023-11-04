import 'package:client/components/user_anchor_menu.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardAppBarUser extends ConsumerWidget {
  const DashboardAppBarUser({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedUser = ref.watch(authProvider);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: UserAnchorMenu(
        icon: Stack(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(loggedUser!.image!),
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
