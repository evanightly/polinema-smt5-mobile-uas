import 'package:client/config/custom_theme.dart';
import 'package:client/screens/admin/admin_login_screen.dart';
import 'package:client/screens/user/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToLoginUser() => Get.to(() => const UserLoginScreen());
    void navigateToLoginAdmin() => Get.to(() => const AdminLoginScreen());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              lightThemeData.colorScheme.primary,
              lightThemeData.colorScheme.primary.withOpacity(.7)
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              'Car.io',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: lightThemeData.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    const Image(
                      image:
                          AssetImage('assets/images/undraw_electric_car.png'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      'EASA Enterprise',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black.withOpacity(.6)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      'Find Your Dream Car Today Right Now!',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            lightColorScheme.primary,
                            lightColorScheme.primary.withOpacity(.5)
                          ],
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        onPressed: navigateToLoginUser,
                        child: const Text(
                          'Login as Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "OR",
                          style: TextStyle(color: Colors.black38),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            lightColorScheme.error,
                            lightColorScheme.error.withOpacity(.5)
                          ],
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: navigateToLoginAdmin,
                        child: const Text(
                          'Login as Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
