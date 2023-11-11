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
      ),
    );
  }

  Dio get adminHttp {
    final auth = ref.read(adminAuthProvider);
    // get state with options header

    return Dio(
      BaseOptions(
        baseUrl: _serverBaseUrl,
        headers: {'Authorization': 'Bearer ${auth!.token}'},
      ),
    );
  }

  Dio get userHttp {
    final auth = ref.read(userAuthProvider);
    // get state with options header

    return Dio(
      BaseOptions(
        baseUrl: _serverBaseUrl,
        headers: {'Authorization': 'Bearer ${auth!.token}'},
      ),
    );
  }
}
