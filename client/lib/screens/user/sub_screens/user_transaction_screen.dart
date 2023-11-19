import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';
import 'package:client/models/user_transaction.dart';
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

    void showDetailTransaction(UserTransaction transaction) {
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
              const SizedBox(height: 8),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Transaction Date:'),
                trailing: Text(transaction.transactionDate),
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
                trailing: Text(transaction.paymentMethod?.name ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Payment Date:'),
                trailing: Text(transaction.paymentDate ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Verified By:'),
                trailing: Text(transaction.verifiedBy?.name ?? ''),
              ),
              ListTile(
                leadingAndTrailingTextStyle:
                    Theme.of(context).textTheme.bodyLarge,
                leading: const Text('Verified At:'),
                trailing: Text(transaction.verifiedDate),
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
                    const SizedBox(height: 8),
                    if (transaction.paymentProof != null)
                      CachedNetworkImage(
                        imageUrl: transaction.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const Row(
                            children: [
                              Icon(Icons.error),
                              SizedBox(width: 8),
                              Text('No payment proof'),
                            ],
                          );
                        },
                      )
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
              if (transaction.detailTransactions != null)
                for (var i = 0; i < transaction.detailTransactions!.length; i++)
                  ListTile(
                    leading: _CarImage(transaction.detailTransactions![i].car),
                    title: Text(transaction.detailTransactions![i].car.name),
                    subtitle: Text(
                      '\$ ${formatNumber(transaction.detailTransactions![i].car.price)}',
                    ),
                    trailing: Text(
                      'x ${transaction.detailTransactions![i].qty}',
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
                    title: Text(data[i].transactionDate),
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

class _CarImage extends StatelessWidget {
  const _CarImage(this.car);

  final Car car;

  @override
  Widget build(BuildContext context) {
    Widget image = const SizedBox.shrink();

    if (car.image != null) {
      image = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_circularRadius),
          bottomLeft: Radius.circular(_circularRadius),
        ),
        child: CachedNetworkImage(
          imageUrl: car.imageUrl,
        ),
      );
    }

    return image;
  }
}
