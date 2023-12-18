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
      state = const AsyncLoading();

      final dio = ref.read(dioHttpProvider);
      final response = await dio.post(
        '/admins/login',
        data: {'email': email, 'password': password},
      );

      final admin = Admin.fromAuthJson(response.data);
      state = AsyncValue.data(admin);

      // Clear admin dashboard appbar actions
      ref.read(adminDashboardActionsProvider.notifier).setActions([]);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/admin');
        LoadingIndicator.dismiss();
      }
    } on DioException catch (d) {
      if (d.type == DioExceptionType.connectionTimeout) {
        if (context.mounted) {
          LoadingIndicator.showError(
            'Server timeout, probably wrong ip address supplied',
          );
        }
      } else {
        if (context.mounted) {
          LoadingIndicator.showError('Failed with error, wrong credentials');
        }
      }
    }
  }

  // Used only for edit profile
  Future<Admin?> get() async {
    final id = state.value?.id;
    final token = state.value?.token;
    final dio = ref.read(dioHttpProvider);
    final response = await dio.get('/admins/$id');
    final data = response.data as Map<String, dynamic>;
    data['admin'] = data;
    data['token'] = token;
    final admin = Admin.fromAuthJson(data);

    return admin;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await get());
  }

  Future<void> logout(BuildContext context) async {
    await ref.read(dioHttpProvider.notifier).http.post('/admins/logout');

    if (context.mounted) {
      await Navigator.pushReplacementNamed(context, '/');
    }
  }

  FutureOr<void> redirectIfNotLogged(BuildContext context) {
    if (state.value == null) {
      Navigator.pushReplacementNamed(context, '/admins/login');
    }
  }

  @override
  FutureOr<Admin?> build() {
    return null;
  }
}
