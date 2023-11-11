import 'package:client/models/admin.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/diohttp.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_auth.g.dart';

@Riverpod(keepAlive: true)
class AdminAuth extends _$AdminAuth {
  void loginAdmin(BuildContext context, String email, String password) async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.post(
      '/admin/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final admin = Admin.fromAuthJson(data['data']);

    state = admin;
    ref.read(adminDashboardActionsProvider.notifier).setActions([]);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  void logout(BuildContext context) async {
    // state = null;
    // ref.read(adminDashboardActionsProvider.notifier).empty();
    // log('Logout');

    await ref.read(dioHttpProvider.notifier).http.post('/admin/logout');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
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
