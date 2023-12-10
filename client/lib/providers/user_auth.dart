import 'package:client/components/loading_indicator.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_auth.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  void loginUser(BuildContext context, String email, String password) async {
    try {
      LoadingIndicator.show();
      state = const AsyncValue.loading();

      final dio = ref.read(dioHttpProvider);
      final response = await dio.post(
        '/users/login',
        data: {'email': email, 'password': password},
      );

      final user = User.fromAuthJson(response.data);
      state = AsyncValue.data(user);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/user');
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

  Future<void> registerUser(
      BuildContext context, String name, String email, String password) async {
    try {
      LoadingIndicator.show();
      state = const AsyncValue.loading();

      final dio = ref.read(dioHttpProvider);
      final response = await dio.post('/users/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      final user = User.fromAuthJson(data['data']);

      state = AsyncValue.data(user);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/user');
        LoadingIndicator.dismiss();
      }
    } catch (e) {
      LoadingIndicator.showError(
          'Failed with error, user with the same email already exists');
    }
  }

  // Used only for edit profile
  Future<User?> get() async {
    try {
      final id = state.value?.id;
      final token = state.value?.token;
      final dio = ref.read(dioHttpProvider);
      final response = await dio.get('/users/$id');
      final data = response.data as Map<String, dynamic>;
      data['user'] = data;
      data['token'] = token;
      final user = User.fromAuthJson(data);

      return user;
    } catch (e) {
      return null;
    }
  }

  Future refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await get());
  }

  Future<void> logout(BuildContext context) async {
    LoadingIndicator.show();

    await ref.read(dioHttpProvider.notifier).http.post('/users/logout');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
      LoadingIndicator.dismiss();
    }
  }

  FutureOr<void> redirectIfNotLogged(BuildContext context) {
    if (state.value == null) {
      Navigator.pushReplacementNamed(context, '/users/login');
    }
  }

  @override
  FutureOr<User?> build() {
    return null;
  }
}
