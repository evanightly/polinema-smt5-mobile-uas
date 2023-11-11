import 'package:client/config/custom_theme.dart';
import 'package:client/providers/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserLoginScreen extends ConsumerStatefulWidget {
  const UserLoginScreen({super.key});

  @override
  ConsumerState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends ConsumerState<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void navigateToRegisterUser() {
    Navigator.pushNamed(context, '/user/register');
  }

  void navigateToLoginAdmin() {
    Navigator.pushNamed(context, '/admin/login');
  }

  void setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void setPassword(String password) {
    setState(() {
      _password = password;
    });
  }

  void login() {
    final auth = ref.read(userAuthProvider.notifier);
    if (_formKey.currentState!.validate()) {
      auth.loginUser(context, _email, _password);
    }
  }

  String? passwordValidator(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

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
            onPressed: navigateToRegisterUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: lightThemeData.colorScheme.primary,
            ),
            child: const Text('Get Started'),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
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
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
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
                              initialValue: _email,
                              autocorrect: true,
                              decoration: InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: lightColorScheme.primary),
                                labelText: 'Email',
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.black),
                              onChanged: setEmail,
                              validator: emailValidator,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: _password,
                              autocorrect: true,
                              decoration: InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: lightColorScheme.primary),
                                labelText: 'Password',
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              onChanged: setPassword,
                              validator: passwordValidator,
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
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: login,
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
      ),
    );
  }
}
