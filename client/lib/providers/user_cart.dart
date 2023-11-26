import 'dart:developer';
import 'dart:io';

import 'package:client/models/user_detail_transaction.dart';
import 'package:client/models/user_transaction.dart';
import 'package:client/providers/diohttp.dart';
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
    return null;
  }

  UserTransaction get() {
    final userTransactions = ref.watch(userTransactionsProvider);

    // get user transaction with status OnGoing
    final UserTransaction userTransaction =
        userTransactions.asData!.value.firstWhere(
      (element) => element.status == Status.OnGoing,
    );

    return userTransaction;
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
        ref.read(userCartProvider.notifier).refresh();
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
      final userTransaction = get();

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
        '/transactions/${userTransaction.id}?_method=PUT',
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

  // refresh
  void refresh() {
    state = get();
  }
}
