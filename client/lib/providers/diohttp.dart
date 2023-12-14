import 'package:client/main.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/user_auth.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diohttp.g.dart';

final ipv4 = dotenv.env['LOCAL_IPv4'];
final receiveTimeout =
    Duration(seconds: int.parse(dotenv.env['DIO_RECEIVE_TIMEOUT']!));
final connectTimeout =
    Duration(seconds: int.parse(dotenv.env['DIO_CONNECT_TIMEOUT']!));

final _serverBaseUrl =
    'http://$ipv4/polinema-smt5-mobile-uas/server/public/api';

@Riverpod(keepAlive: true)
class DioHttp extends _$DioHttp {
  BaseOptions options = BaseOptions(
    baseUrl: _serverBaseUrl,
    receiveTimeout: receiveTimeout,
    connectTimeout: connectTimeout,
    headers: {'Accept': 'application/json'},
  );

  void addInterceptor(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Do something before request is sent
          return handler.next(options); //continue
        },
        onResponse: (response, handler) {
          // Do something with response data
          // print(response.data);
          // print(response.headers);

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 422) {
            EasyLoading.showError(
              'Validation Error \n ${e.response?.data['errors']}',
              maskType: EasyLoadingMaskType.black,
              duration: const Duration(seconds: 5),
            );

            // DOESN'T WORK
            ElegantNotification.error(
              title: const Text("Validation Error"),
              description: ListView(children: [
                for (var error in e.response?.data['errors'].values)
                  Text(error[0].toString())
              ]),
              background: Theme.of(globalNavigatorKey.currentContext!)
                  .colorScheme
                  .background,
            ).show(globalNavigatorKey.currentContext!);
          }
          // Do something with response error
          return handler.next(e); //continue
        },
      ),
    );
  }

  @override
  Dio build() {
    Dio dio = Dio(options);
    addInterceptor(dio);
    return dio;
  }

  Dio get http {
    Dio dio;
    final isAdminLoggedIn = ref.read(adminAuthProvider).valueOrNull;
    final isUserLoggedIn = ref.read(userAuthProvider).valueOrNull;

    if (isAdminLoggedIn != null) {
      options.headers = {
        ...options.headers,
        'Authorization': 'Bearer ${isAdminLoggedIn.token}'
      };
    } else if (isUserLoggedIn != null) {
      options.headers = {
        ...options.headers,
        'Authorization': 'Bearer ${isUserLoggedIn.token}'
      };
    }

    dio = Dio(options);
    addInterceptor(dio);

    return dio;
  }
}
