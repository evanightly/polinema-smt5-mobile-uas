import 'package:client/config/custom_theme.dart';
import 'package:client/screens/user/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});


  void navigateToLogin() => Get.to(() => const UserLoginScreen());
  void registerUser() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: lightThemeData.colorScheme.primary,
        foregroundColor: lightThemeData.colorScheme.onPrimary,
        actions: [
          const Text('Already have account?'),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: navigateToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: lightThemeData.colorScheme.primary,
            ),
            child: const Text('Sign In'),
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
                'Let\'s Connect!',
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
                      'Create your account',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Enter your details below',
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
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                            keyboardType: TextInputType.name,
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
                                'Sign up',
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

