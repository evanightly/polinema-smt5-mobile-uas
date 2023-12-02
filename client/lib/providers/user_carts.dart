import 'package:client/components/loading_indicator.dart';
import 'package:client/models/car.dart';
import 'package:client/models/cart.dart';
import 'package:client/models/cart_item.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/diohttp.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/user_transactions.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_carts.g.dart';

@Riverpod(keepAlive: true)
class UserCarts extends _$UserCarts {
  @override
  FutureOr<Cart?> build() async {
    return await get();
  }

  // get
  Future<Cart?> get() async {
    try {
      final user = ref.read(userAuthProvider);
      final dio = ref.read(dioHttpProvider.notifier);
      final response =
          await dio.http.get('/users/${user!.id}/carts') as dynamic;
      final data = response.data as dynamic;

      return Cart.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> add(BuildContext context, Car car, [int quantity = 1]) async {
    final user = ref.read(userAuthProvider);
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final response = await dio.http.post(
        '/carts',
        data: {'user_id': user!.id, 'car_id': car.id, 'quantity': quantity},
      );

      if (response.statusCode == 201) {
        await ref.read(carsProvider.notifier).refresh();
        await ref.read(userTransactionsProvider.notifier).refresh();
        await refresh();
      }

      LoadingIndicator.dismiss();
      return;
    } on DioException catch (e) {
      if (context.mounted) {
        ElegantNotification.error(
          title: const Text("Error"),
          description: Text(e.response?.data['message']),
          background: Theme.of(context).colorScheme.background,
        ).show(context);
      }
    }
  }

  Future<void> put(BuildContext context, CartItem cartItem) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final response = await dio.http.post(
        '/carts/${cartItem.id}?_method=PUT',
        data: cartItem.toJson(),
      );

      if (response.statusCode == 200) {
        await refresh();
      }

      LoadingIndicator.dismiss();
    } on DioException catch (_) {
      // print(_);
    }
  }

  Future<void> delete(BuildContext context, CartItem cartItem) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();
      final response = await dio.http.delete('/carts/${cartItem.id}');

      if (response.statusCode == 204) {
        await refresh();
      }

      LoadingIndicator.dismiss();
      return;
    } on DioException catch (_) {}
  }
}
