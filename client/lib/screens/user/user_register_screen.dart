import 'package:client/config/custom_theme.dart';
import 'package:client/providers/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRegisterScreen extends ConsumerStatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  ConsumerState<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends ConsumerState<UserRegisterScreen> {
  String _email = '';
  String _name = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void navigateToLogin() {
      Navigator.pushReplacementNamed(context, '/user/login');
    }

    void registerUser() {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      ref
          .read(userAuthProvider.notifier)
          .registerUser(context, _name, _email, _password);
    }

    void setEmail(String email) {
      setState(() {
        _email = email;
      });
    }

    void setName(String name) {
      setState(() {
        _name = name;
      });
    }

    void setPassword(String password) {
      setState(() {
        _password = password;
      });
    }

    String? emailValidator(String? value) {
      if (value!.trim().isEmpty) {
        return 'Email is required';
      }

      if (!value.contains('@')) {
        return 'Email is not valid';
      }

      return null;
    }

    String? nameValidator(String? value) {
      if (value!.trim().isEmpty) {
        return 'Username is required';
      }

      return null;
    }

    String? passwordValidator(String? value) {
      if (value!.trim().isEmpty) {
        return 'Password is required';
      }

      // if (value.length < 6) {
      //   return 'Password must be at least 6 characters';
      // }

      return null;
    }

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
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          TextFormField(
                            initialValue: _email,
                            autocorrect: false,
                            decoration: InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: lightColorScheme.primary),
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                            onChanged: setEmail,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: _name,
                            autocorrect: false,
                            decoration: InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: lightColorScheme.primary),
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.name,
                            validator: nameValidator,
                            onChanged: setName,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: _password,
                            autocorrect: false,
                            decoration: InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: lightColorScheme.primary),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            validator: passwordValidator,
                            obscureText: true,
                            onChanged: setPassword,
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
