import 'dart:developer';

import 'package:client/models/car.dart';
import 'package:client/models/user_transaction.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/diohttp.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/user_cart.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_transactions.g.dart';

@Riverpod(keepAlive: true)
class UserTransactions extends _$UserTransactions {
  @override
  Future<List<UserTransaction>> build() async {
    return await get();
  }

  Future<List<UserTransaction>> get() async {
    try {
      final user = ref.read(userAuthProvider);
      final dio = ref.read(dioHttpProvider.notifier);
      // print('Token');
      // print(dio.http.options.headers);
      // print('URL');
      // print('${dio.http.options.baseUrl}/users/${user!.id}}');
      final response = await dio.http.get('/users/${user!.id}');
      final data = response.data as dynamic;
      final transactions = data['transactions'] as List<dynamic>;

      final userTransactions = transactions.map(
        (transaction) {
          return UserTransaction.fromJson(transaction);
        },
      ).toList();
      return userTransactions;
    } catch (e) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }

  Future<void> add(BuildContext context, Car car) async {
    try {
      final user = ref.read(userAuthProvider);
      final dio = ref.read(dioHttpProvider.notifier);
      final cars = ref.read(carsProvider.notifier);
      final response = await dio.http.post(
        '/transactions',
        data: {'user_id': user!.id, 'car': car.toJson()},
      );

      log(response.data.toString());

      if (response.statusCode == 200) {
        await ref.read(carsProvider.notifier).refresh();
        await ref.read(userTransactionsProvider.notifier).refresh();
        ref.read(userCartProvider.notifier).refresh();

        if (context.mounted) {
          ElegantNotification.success(
            title: const Text("Success"),
            description: Text(response.data['message']),
            background: Theme.of(context).colorScheme.background,
          ).show(context);
        }

        await cars.refresh();
      }
      final data = response.data as dynamic;
      final newTransaction = UserTransaction.fromJson(data);
      state.whenData((transactions) {
        transactions.add(newTransaction);
        state = AsyncValue.data(transactions);
      });

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
}
