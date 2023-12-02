import 'package:client/components/loading_indicator.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users.g.dart';

dynamic generateUserMetadata(User user) {
  return {
    'name': user.name,
    'email': user.email,
    'password': user.password,
    'address': user.address,
  };
}

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
    final users = data.map((user) => User.fromJson(user)).toList();

    return users;
  }

  refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  void add(User user) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final formData = FormData.fromMap({
        ...generateUserMetadata(user),
        'image': await MultipartFile.fromFile(user.uploadImage!.path),
      });

      await dio.http.post('/users', data: formData);

      refresh();

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to add user');
    }
  }

  void put(User user) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      FormData formData = FormData.fromMap(generateUserMetadata(user));

      // If user uploaded a new image, then add it to the form data
      if (user.uploadImage != null) {
        formData = FormData.fromMap({
          ...generateUserMetadata(user),
          'image': await MultipartFile.fromFile(user.uploadImage!.path),
        });
      }

      await dio.http.post('/users/${user.id}?_method=PUT', data: formData);

      refresh();

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to update user');
    }
  }

  void delete(User user) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      await dio.http.delete('/users/${user.id}');

      refresh();

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to delete user');
    }
  }
}
