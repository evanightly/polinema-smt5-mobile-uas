// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:client/components/loading_indicator.dart';
import 'package:client/models/transaction.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/diohttp.dart';
import 'package:client/providers/user_auth.dart';
import 'package:client/providers/user_carts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_transactions.g.dart';

@Riverpod(keepAlive: true)
class UserTransactions extends _$UserTransactions {
  @override
  Future<List<Transaction>> build() async => await get();

  Future<List<Transaction>> get() async {
    try {
      final user = ref.read(userAuthProvider);
      final dio = ref.read(dioHttpProvider.notifier);
      final response = await dio.http.get('/users/${user!.id}/transactions');
      final data = response.data as dynamic;
      final transactions = data['transactions'] as List<dynamic>;

      return transactions.map((t) => Transaction.fromJson(t)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> post(
    BuildContext context,
    User loggedUser,
    String deliveryAddress,
    PaymentMethod paymentMethod,
    File paymentProof,
  ) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      FormData formData = FormData.fromMap({
        'user_id': loggedUser.id,
        'delivery_address': deliveryAddress,
        'payment_method': paymentMethod.name,
        'payment_proof': await MultipartFile.fromFile(paymentProof.path),
      });

      final response = await dio.http.post('/transactions', data: formData);

      if (response.statusCode == 201) {
        await ref.read(userCartsProvider.notifier).refresh();
        await ref.read(userTransactionsProvider.notifier).refresh();
        if (context.mounted) {
          Navigator.pop(context);
        }
      }

      LoadingIndicator.dismiss();
    } on DioException catch (_) {}
  }

  Future<void> put(BuildContext context, Transaction userTransaction) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      FormData formData = FormData.fromMap({
        'delivery_address': userTransaction.delivery_address,
        'payment_method': userTransaction.payment_method,
      });

      // If user uploaded a new image, then add it to the form data
      if (userTransaction.upload_payment_proof != null) {
        formData = FormData.fromMap({
          'delivery_address': userTransaction.delivery_address,
          'payment_method': userTransaction.payment_method,
          'payment_proof': await MultipartFile.fromFile(
            userTransaction.upload_payment_proof!.path,
          ),
        });
      }

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

      LoadingIndicator.dismiss();
    } on DioException catch (_) {}
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }
}
