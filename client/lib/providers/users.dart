import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
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
    } catch (e) {
      state = AsyncValue.error('Failed to add users', StackTrace.current);
    }
  }

  void put(User user) async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      final formData = FormData.fromMap({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'image': await MultipartFile.fromFile(user.uploadImage!.path),
      });

      final response =
          await dio.http.put('/users/${user.id}', data: formData);
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 3));
        refresh();
      } else {
        // state = AsyncValue.error('Failed to update users', StackTrace.current);
        // Force reload data
        refresh();
      }
    } catch (e) {
      state = AsyncValue.error('Failed to update users', StackTrace.current);
    }
  }

  Future<bool> delete(String id) async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.http.delete('/users/$id');
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 3));
      refresh();
      return true;
    } else {
      return false;
    }
  }

  Future<User> login(String email, String password) async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.post('/users/login', data: {
      'email': email,
      'password': password,
    });
    final data = response.data as Map<String, dynamic>;
    final user = User.fromJson(data);
    return user;
  }

  Future<User> register(String name, String email, String password) async {
    final dio = ref.read(dioHttpProvider);
    final response = await dio.post('/users/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    final data = response.data as Map<String, dynamic>;
    final user = User.fromJson(data);
    return user;
  }
}
