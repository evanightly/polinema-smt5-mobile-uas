import 'package:client/models/admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProviderNotifier extends StateNotifier<Admin?> {
  AuthProviderNotifier() : super(null);

  void login(BuildContext context) {
    state = Admin(
      '1',
      'Ruby Nicholas',
      'a@gmail.com',
      'nicholasN',
      true,
      'assets/images/dog.jpg',
    );

    Navigator.pushReplacementNamed(context, '/admin');
  }

  void logout() {
    state = null;
  }

  void redirectIfNotLogged(BuildContext context) {
    if (state == null) {
      Navigator.pushReplacementNamed(context, '/admin/login');
    }
  }
}

final authProvider = StateNotifierProvider<AuthProviderNotifier, Admin?>((ref) {
  return AuthProviderNotifier();
});
