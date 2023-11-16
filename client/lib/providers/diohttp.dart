import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/user_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diohttp.g.dart';

final ipv4 = dotenv.env['LOCAL_IPv4'];

@Riverpod(keepAlive: true)
class DioHttp extends _$DioHttp {
  final _serverBaseUrl =
      'http://$ipv4/polinema-smt5-mobile-uas/server/public/api';

  @override
  Dio build() {
    return Dio(
      BaseOptions(
        baseUrl: _serverBaseUrl,
        connectTimeout: const Duration(seconds: 15),
      ),
    );
  }

  Dio get http {
    final isAdminLoggedIn = ref.read(adminAuthProvider);
    final isUserLoggedIn = ref.read(userAuthProvider);

    // Default options
    BaseOptions options = BaseOptions(baseUrl: _serverBaseUrl);

    if (isAdminLoggedIn != null) {
      options = BaseOptions(
        baseUrl: _serverBaseUrl,
        headers: {'Authorization': 'Bearer ${isAdminLoggedIn.token}'},
      );
    } else if (isUserLoggedIn != null) {
      options = BaseOptions(
        baseUrl: _serverBaseUrl,
        headers: {'Authorization': 'Bearer ${isUserLoggedIn.token}'},
      );
    }

    return Dio(options);
  }
}
