import 'dart:developer';

import 'package:client/models/admin.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
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

  void logout(BuildContext context) {
    state = null;
    ref.read(adminDashboardActionsProvider.notifier).empty();
    log('Logout');
    Navigator.pushReplacementNamed(context, '/');
  }

  void redirectIfNotLogged(BuildContext context) {
    if (state == null) {
      Navigator.pushReplacementNamed(context, '/admin/login');
    }
  }

  @override
  Admin? build() {
    return null;
  }
}
