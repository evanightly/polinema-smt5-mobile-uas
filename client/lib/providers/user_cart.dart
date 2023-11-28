import 'dart:developer';
import 'dart:io';

import 'package:client/components/loading_indicator.dart';
import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';
import 'package:client/models/user_detail_transaction.dart';
import 'package:client/models/user_transaction.dart';
import 'package:client/providers/cars.dart';
import 'package:client/providers/diohttp.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/user_transactions.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_cart.g.dart';

@Riverpod(keepAlive: true)
class UserCart extends _$UserCart {
  @override
  UserTransaction? build() {
    state = null;
    ref.listen(userTransactionsProvider, (previous, next) {
      next.maybeWhen(
          data: (data) {
            if (data.isEmpty) {
              return null;
            }
            // get user transaction with status OnGoing
            final userTransaction = data.firstWhere(
              (transaction) => transaction.status == Status.OnGoing,
            );

            state = userTransaction;
          },
          orElse: () => state = null);
    });

    return state;
  }

  // watch total price
  num get totalPrice {
    final userTransactions = ref.watch(userTransactionsProvider);
    try {
      final total = userTransactions.asData!.value
          .firstWhere((transaction) => transaction.status == Status.OnGoing)
          .total;
      return formatNumber(total);
    } catch (_) {
      return 0;
    }
  }

  Future<void> deleteCartItem(
      BuildContext context, UserDetailTransaction detailTransaction) async {
    try {
      // print('deleted');
      final dio = ref.read(dioHttpProvider.notifier);
      // print('Token');
      // print(dio.http.options.headers);
      // print('URL');
      // print(
      //     '${dio.http.options.baseUrl}/detail-transactions/${detailTransaction.id}');
      final response =
          await dio.http.delete('/detail-transactions/${detailTransaction.id}');

      if (response.statusCode == 200) {
        await ref.read(userTransactionsProvider.notifier).refresh();
        if (context.mounted) {
          ElegantNotification.success(
            title: const Text('Success'),
            description: const Text('Item deleted'),
            background: Theme.of(context).colorScheme.background,
          ).show(context);
          Navigator.pop(context);
        }
      }
    } on DioException catch (_) {}
  }

  Future<void> modifyCartItemQty(BuildContext context,
      UserDetailTransaction detailTransaction, num qty) async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      // print('Token');
      // print(dio.http.options.headers);
      // print('URL');
      // print(
      //     '${dio.http.options.baseUrl}/detail-transactions/${detailTransaction.id}');

      final response = await dio.http.put(
        '/detail-transactions/${detailTransaction.id}',
        data: {'qty': qty},
      );

      if (response.statusCode == 200) {
        ref.read(userTransactionsProvider.notifier).refresh();
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } on DioException catch (_) {}
  }

  Future<void> checkout(BuildContext context, String address,
      PaymentMethod paymentMethod, File? file) async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      final formData = FormData.fromMap({
        'delivery_address': address,
        'payment_method': paymentMethod.name,
        'payment_proof': await MultipartFile.fromFile(file!.path),
      });

      // print('Token');
      // print(dio.http.options.headers);
      // print('URL');
      // print('${dio.http.options.baseUrl}/users/${userTransaction.id}?_method=PUT');

      final response = await dio.http.post(
        '/transactions/${state!.id}?_method=PUT',
        data: formData,
      );

      if (response.statusCode == 200) {
        ref.read(userTransactionsProvider.notifier).refresh();
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } on DioException catch (_) {
      log(_.toString());
    }
  }

  Future<void> add(BuildContext context, Car car, [int qty = 1]) async {
    final user = ref.read(userAuthProvider);
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final response = await dio.http.post(
        '/transactions',
        data: {'user_id': user!.id, 'car_id': car.id, 'qty': qty},
      );

      // print(response.statusCode);
      // print(response);

      if (response.statusCode == 201) {
        await ref.read(carsProvider.notifier).refresh();
        await ref.read(userTransactionsProvider.notifier).refresh();
      }

      // final data = response.data as dynamic;
      // final newTransaction = UserTransaction.fromJson(data);
      // state.whenData((transactions) {
      //   transactions.add(newTransaction);
      //   state = AsyncValue.data(transactions);
      // });

      // return;

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

  Future<void> delete(
      BuildContext context, UserDetailTransaction detailTransaction) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();
      final response = await dio.http
          .delete('/detail-transactions/${detailTransaction.id} ');

      if (response.statusCode == 204) {
        await ref.read(userTransactionsProvider.notifier).refresh();
      }
      LoadingIndicator.dismiss();
      return;
    } on DioException catch (_) {}
  }
}
