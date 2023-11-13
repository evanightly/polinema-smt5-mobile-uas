import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users.g.dart';

@Riverpod(keepAlive: true)
class Users extends _$Users {
  @override
  Future<List<User>> build() async {
    return await get();
  }

  // get all users
  Future<List<User>> get() async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.http.get('/users');
    final data = response.data as List<dynamic>;
    final users = data.map(
      (user) {
        return User.fromJson(user);
      },
    ).toList();

    return users;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  void add(User user) async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        status: 'Loading...',
      );
      print(user.uploadImage!.path);
      final dio = ref.read(dioHttpProvider.notifier);
      final formData = FormData.fromMap({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'image': await MultipartFile.fromFile(user.uploadImage!.path),
      });

      final response = await dio.http.post('/users', data: formData);
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 3));
        refresh();
      } else {
        // state = AsyncValue.error('Failed to add users', StackTrace.current);
        // Force reload data
        refresh();
      }
      EasyLoading.dismiss();
    } catch (e) {
      state = AsyncValue.error('Failed to add users', StackTrace.current);
    }
  }

  void put(User user) async {
    try {
      print(user.uploadImage!.path);
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        status: 'Loading...',
      );

      FormData formData;

      if (user.uploadImage != null) {
        print('yes');
        formData = FormData.fromMap({
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'image': await MultipartFile.fromFile(user.uploadImage!.path),
        });
      } else {
        print('no');
        formData = FormData.fromMap({
          'name': user.name,
          'email': user.email,
          'password': user.password,
        });
      }

      print('formData');
      print(formData.fields);
      final dio = ref.read(dioHttpProvider.notifier);

      final response =
          await dio.http.post('/users/${user.id}?_method=PUT', data: formData);
      if (response.statusCode == 200) {
        refresh();
      } else {
        refresh();
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError('Failed to update users');
      // state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<bool> delete(String id) async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      status: 'Loading...',
    );

    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.http.delete('/users/$id');
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 3));
      refresh();
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.showError('Failed to delete users');
      return false;
    }
  }
}
