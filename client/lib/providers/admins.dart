import 'package:client/models/admin.dart';
import 'package:client/providers/diohttp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admins.g.dart';

@Riverpod(keepAlive: true)
class Admins extends _$Admins {
  @override
  Future<List<Admin>> build() async {
    return await get();
  }

  Future<List<Admin>> get() async {
    final dio = ref.read(dioHttpProvider.notifier);
    final response = await dio.adminHttp.get('/admins');
    final data = response.data as List<dynamic>;
    final admins = data.map(
      (admin) {
        return Admin.fromJson(admin);
      },
    ).toList();

    return admins;
  }
}
