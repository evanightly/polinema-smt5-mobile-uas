import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diohttp.g.dart';

final ipv4 = dotenv.env['LOCAL_IPv4'];

@Riverpod(keepAlive: true)
class DioHttp extends _$DioHttp {
  @override
  Dio build() {
    final serverBaseUrl =
        'http://$ipv4/polinema-smt5-mobile-uas/server/public/';
    return Dio(BaseOptions(
      baseUrl: serverBaseUrl,
    ));
  }
}
