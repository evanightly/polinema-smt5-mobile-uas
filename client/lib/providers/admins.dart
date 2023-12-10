import 'package:client/components/loading_indicator.dart';
import 'package:client/models/admin.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admins.g.dart';

dynamic generateAdminMetadata(Admin admin) {
  return {
    'name': admin.name,
    'email': admin.email,
    'password': admin.password,
    'is_super_admin': admin.isSuperAdmin ? "on" : null,
  };
}

@Riverpod(keepAlive: true)
class Admins extends _$Admins {
  @override
  Future<List<Admin>> build() async {
    return await get();
  }

  Future<List<Admin>> get() async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.http.get('/admins');
    final data = response.data as List<dynamic>;
    final admins = data.map((admin) => Admin.fromJson(admin)).toList();
    return admins;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> add(Admin admin) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final formData = FormData.fromMap({
        ...generateAdminMetadata(admin),
        'image': await MultipartFile.fromFile(admin.uploadImage!.path),
      });

      await dio.http.post('/admins', data: formData);

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to add admin');
    }
  }

  Future<void> put(Admin admin) async {
    final dio = ref.read(dioHttpProvider.notifier);
    try {
      LoadingIndicator.show();

      FormData formData = FormData.fromMap(generateAdminMetadata(admin));

      // If admin uploaded a new image, then add it to the form data
      if (admin.uploadImage != null) {
        formData = FormData.fromMap({
          ...generateAdminMetadata(admin),
          'image': await MultipartFile.fromFile(admin.uploadImage!.path),
        });
      }

      await dio.http.post('/admins/${admin.id}?_method=PUT', data: formData);

      LoadingIndicator.dismiss();
    } catch (_) {
      LoadingIndicator.showError('Failed to update admin');
    }
  }

  Future<void> delete(Admin admin) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      await dio.http.delete('/admins/${admin.id}');

      LoadingIndicator.dismiss();
    } catch (_) {
      // LoadingIndicator.showError('Failed to delete admin');
    }
  }
}
