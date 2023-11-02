import 'dart:convert';

import 'package:client/config/custom_theme.dart';
import 'package:client/screens/admin/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  void navigateToLoginAdmin() => Get.to(() => const AdminLoginScreen());
  void registerUser() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: lightThemeData.colorScheme.primary,
        foregroundColor: lightThemeData.colorScheme.onPrimary,
        actions: [
          const Text('Don\'t have account?'),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: navigateToLoginAdmin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: lightThemeData.colorScheme.primary,
            ),
            child: const Text('Get Started'),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Container(
        width: double.infinity,
        color: lightThemeData.colorScheme.primary,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: lightThemeData.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 80),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Sign in',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Enter your credentials below',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black.withOpacity(.6)),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          TextFormField(
                            autocorrect: false,
                            decoration: InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: lightColorScheme.primary),
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            autocorrect: false,
                            decoration: InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: lightColorScheme.primary),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          Container(
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
                              onPressed: registerUser,
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Row(children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text("OR"),
                            SizedBox(width: 20),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 20),
                          Container(
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
                                  backgroundColor: Colors.transparent),
                              onPressed: registerUser,
                              child: const Text(
                                'Login as Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 380)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}