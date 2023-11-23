import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_auth.g.dart';

@Riverpod(keepAlive: true)
class UserAuth extends _$UserAuth {
  void loginUser(BuildContext context, String email, String password) async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        status: 'Loading...',
      );
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
        EasyLoading.dismiss();
      }
    } on DioException catch (d) {
      if (d.type == DioExceptionType.connectionTimeout) {
        EasyLoading.showError(
          'Server timeout, probably wrong ip address supplied',
          duration: const Duration(seconds: 5),
        );
      }
    } on DioException catch (e) {
      print(e);
      EasyLoading.showError('Failed with error, user not found');
    }
  }

  void registerUser(
      BuildContext context, String name, String email, String password) async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        status: 'Loading...',
      );

      final dio = ref.read(dioHttpProvider);
      final response = await dio.post('/user/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      final user = User.fromAuthJson(data['data']);

      state = user;

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/user');
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.showError(
          'Failed with error, user with the same email already exists');
    }
  }

  void logout(BuildContext context) async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      status: 'Loading...',
    );

    await ref.read(dioHttpProvider.notifier).http.post('/user/logout');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
      EasyLoading.dismiss();
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
