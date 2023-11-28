import 'package:client/models/user_transaction.dart';
import 'package:client/providers/diohttp.dart';
import 'package:client/providers/user_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_transactions.g.dart';

@Riverpod(keepAlive: true)
class UserTransactions extends _$UserTransactions {
  @override
  Future<List<UserTransaction>> build() async => await get();

  Future<List<UserTransaction>> get() async {
    try {
      final user = ref.read(userAuthProvider);
      final dio = ref.read(dioHttpProvider.notifier);
      final response = await dio.http.get('/users/${user!.id}');
      final data = response.data as dynamic;
      final transactions = data['transaction'] as List<dynamic>;

      final userTransactions = transactions
          .map(
            (transaction) => UserTransaction.fromJson(transaction),
          )
          .toList();
      return userTransactions;
    } catch (e) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => get());
  }
}
