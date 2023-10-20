import 'package:client/components/user_anchor_menu.dart';
import 'package:client/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardAppBarUser extends StatelessWidget {
  const DashboardAppBarUser({super.key});
  static AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: UserAnchorMenu(
        icon: Stack(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                authController.loggedUser.image!,
              ),
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
