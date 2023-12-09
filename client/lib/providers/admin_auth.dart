import 'package:client/components/loading_indicator.dart';
import 'package:client/models/admin.dart';
import 'package:client/providers/admin_dashboard_actions.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_auth.g.dart';

@Riverpod(keepAlive: true)
class AdminAuth extends _$AdminAuth {
  void loginAdmin(BuildContext context, String email, String password) async {
    try {
      LoadingIndicator.show();
      final dio = ref.read(dioHttpProvider);
      final response = await dio.post(
        '/admins/login',
        data: {'email': email, 'password': password},
      );

      final admin = Admin.fromAuthJson(response.data);

      state = admin;
      ref.read(adminDashboardActionsProvider.notifier).setActions([]);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/admin');
        LoadingIndicator.dismiss();
      }
    } on DioException catch (d) {
      if (d.type == DioExceptionType.connectionTimeout) {
        LoadingIndicator.showError(
          'Server timeout, probably wrong ip address supplied',
        );
      }
    } catch (e) {
      LoadingIndicator.showError('Failed with error, admin not found');
    }
  }

  // Used only for edit profile
  Future<Admin?> get() async {
    try {
      final id = state?.id;
      final token = state?.token;
      final dio = ref.read(dioHttpProvider);
      final response = await dio.get('/admins/$id');
      final data = response.data as Map<String, dynamic>;
      data['admin'] = data;
      data['token'] = token;
      final admin = Admin.fromAuthJson(data);

      return admin;
    } catch (e) {
      return null;
    }
  }

  Future refresh() async {
    state = await get();
  }

  void logout(BuildContext context) async {
    // state = null;
    // ref.read(adminDashboardActionsProvider.notifier).empty();
    // log('Logout');
    LoadingIndicator.show();

    await ref.read(dioHttpProvider.notifier).http.post('/admins/logout');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
      LoadingIndicator.dismiss();
    }
  }

  void redirectIfNotLogged(BuildContext context) {
    if (state == null) {
      Navigator.pushReplacementNamed(context, '/admins/login');
    }
  }

  @override
  Admin? build() {
    return null;
  }
}
