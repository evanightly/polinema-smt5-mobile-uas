import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/transaction.dart';
import 'package:client/providers/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

const double _circularRadius = 6;
const double _leftPadding = 16;

class UserTransactionScreen extends ConsumerWidget {
  const UserTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    final userTransactions = ref.watch(userTransactionsProvider);

    Future<void> onRefresh() async {
      await ref.read(userTransactionsProvider.notifier).refresh();
    }

    Widget statusText(String status) {
      Color textColor = Colors.green;
      if (status == 'OnGoing') {
        textColor = Colors.blue;
      } else if (status == 'Pending') {
        textColor = Colors.orange;
      } else if (status == 'Rejected') {
        textColor = Colors.red;
      }

      return Text(
        status,
        style: TextStyle(
          color: textColor,
        ),
      );
    }

    void showDetailTransaction(Transaction transaction) {
      showDialog(
        context: context,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Transaction Detail'),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(_leftPadding),
                child: Text(
                  'Transaction Detail:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Transaction Date:'),
                trailing: Text(transaction.formatted_created_at ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Status:'),
                trailing: statusText(transaction.status.name),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Payment Method:'),
                trailing: Text(transaction.payment_method?.name ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Payment Date:'),
                trailing: Text(transaction.payment_date ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Verified By:'),
                trailing: Text(transaction.verified_by?.name ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Verified At:'),
                trailing: Text(transaction.formatted_verified_at ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(_leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Address:',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                      transaction.delivery_address ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Total:'),
                trailing: Text('\$ ${formatNumber(transaction.total)}'),
              ),
              Padding(
                padding: const EdgeInsets.all(_leftPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Proof:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (transaction.payment_proof != null)
                      Image(
                        image: transaction.imageProviderWidget,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Row(
                            children: [
                              Icon(Icons.error),
                              SizedBox(width: 8),
                              Text('No payment proof'),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(_leftPadding),
                child: Text(
                  'Items:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (transaction.detail_transactions != null &&
                  transaction.detail_transactions!.isNotEmpty)
                for (var i = 0;
                    i < transaction.detail_transactions!.length;
                    i++)
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(_circularRadius),
                        bottomLeft: Radius.circular(_circularRadius),
                      ),
                      child: Image(
                        image: transaction
                            .detail_transactions![i].car.imageProviderWidget,
                      ),
                    ),
                    title: Text(transaction.detail_transactions![i].car.name),
                    subtitle: Text(
                      '\$ ${formatNumber(transaction.detail_transactions![i].car.price)}',
                    ),
                    trailing: Text(
                      'x ${transaction.detail_transactions![i].qty}',
                    ),
                  ),
            ],
          ),
        ),
      );
    }

    return userTransactions.when(
      data: (data) {
        return LiquidPullToRefresh(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          child: ListView(
            children: [
              if (data.isNotEmpty)
                for (var i = 0; i < data.length; i++)
                  ListTile(
                    onTap: () => showDetailTransaction(data[i]),
                    leading: Text((i + 1).toString()),
                    title: Text(data[i].formatted_created_at ?? ''),
                    subtitle: statusText(data[i].status.name),
                    trailing: Text('Total: \$ ${formatNumber(data[i].total)}'),
                  ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
