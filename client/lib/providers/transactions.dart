import 'package:client/components/loading_indicator.dart';
import 'package:client/models/transaction.dart';
import 'package:client/providers/admin_auth.dart';
import 'package:client/providers/diohttp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  @override
  Future<List<Transaction>> build() async => await get();

  Future<List<Transaction>> get() async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      final response = await dio.http.get('/transactions');
      final transactions = response.data as List<dynamic>;

      return transactions.map((t) => Transaction.fromJson(t)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> put(
      BuildContext context, Transaction transaction, Status status) async {
    final dio = ref.read(dioHttpProvider.notifier);
    final admin = ref.read(adminAuthProvider).valueOrNull;

    try {
      LoadingIndicator.show();

      final response = await dio.http.put(
        '/transactions/${transaction.id}',
        data: {
          'status': status.name,
          'verified_by': admin!.id,
          'verified_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        await refresh();
      }

      LoadingIndicator.dismiss();
    } on DioException catch (_) {}
  }

  Future<void> delete(BuildContext context, Transaction userTransaction) async {
    final dio = ref.read(dioHttpProvider.notifier);

    try {
      LoadingIndicator.show();

      final response = await dio.http.delete(
        '/transactions/${userTransaction.id}',
      );

      if (response.statusCode == 200) {
        await refresh();
      }

      LoadingIndicator.dismiss();
    } on DioException catch (_) {}
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await get());
  }
}
