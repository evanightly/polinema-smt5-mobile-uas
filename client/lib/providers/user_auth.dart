import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_auth.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  void loginUser(BuildContext context, String email, String password) async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.post(
      '/user/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;

    final user = User.fromAuthJson(data['data']);

    state = user;

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/user');
    }
  }

  void logout(BuildContext context) async {
    // state = null;
    // ref.read(adminDashboardActionsProvider.notifier).empty();
    // log('Logout');

    await ref.read(dioHttpProvider.notifier).userHttp.post('/user/logout');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void redirectIfNotLogged(BuildContext context) {
    if (state == null) {
      Navigator.pushReplacementNamed(context, '/user/login');
    }
  }

  @override
  User? build() {
    return null;
  }
}
