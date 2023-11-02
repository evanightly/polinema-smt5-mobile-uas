import 'package:client/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void navigateToLogin() => Get.to(() => const LoginScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          const Text('Already have account?'),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: navigateToLogin,
            child: const Text('Sign In'),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(
                'Register User',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 80),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(children: [
                  const SizedBox(height: 20),
                  Text(
                    'Create your account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Enter your details below',
                    style: Theme.of(context).textTheme.bodyLarge!,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        TextFormField(
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 380)
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
