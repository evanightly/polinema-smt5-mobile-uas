import 'package:client/models/user_transaction.dart';
import 'package:client/providers/diohttp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_transactions.g.dart';

@Riverpod(keepAlive: true)
class UserTransactions extends _$UserTransactions {
  
  @override
  UserTransaction? build() {
    return null;
  }

  Future<List<UserTransaction>> get() async {
    try {
      final dio = ref.read(dioHttpProvider.notifier);
      final response = await dio.http.get('/user-transactions');
      final data = response.data as List<dynamic>;
      final userTransactions = data.map(
        (userTransaction) {
          return UserTransaction.fromJson(userTransaction);
        },
      ).toList();

      return userTransactions;
    } catch (e) {
      return [];
    }
  }
}
