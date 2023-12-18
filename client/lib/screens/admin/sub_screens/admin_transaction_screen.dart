import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/transaction.dart';
import 'package:client/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

const double _circularRadius = 6;
const double _leftPadding = 16;

class AdminTransactionScreen extends ConsumerWidget {
  const AdminTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    final transactions = ref.watch(transactionsProvider);

    Future<void> onRefresh() async {
      await ref.read(transactionsProvider.notifier).refresh();
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
        builder: (context) => Consumer(
          builder: (ctx, ref, child) {
            final transactions = ref.read(transactionsProvider.notifier);
            void changeStatus() {
              void redirectToTransactionList() {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_circularRadius),
                    ),
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_circularRadius),
                    ),
                    1,
                  ),
                  surfaceTintColor: Theme.of(context).colorScheme.surface,
                  // backgroundColor: Theme.of(context).colorScheme.surface,
                  title: const Text('Change Status'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (transaction.status != Status.Finished &&
                          transaction.status != Status.Rejected) ...[
                        if (transaction.status == Status.Verified) ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(_circularRadius),
                              color: Colors.green[50],
                            ),
                            child: ListTile(
                              tileColor: Colors.green[50],
                              title: const Row(
                                children: [
                                  Icon(Icons.thumb_up, color: Colors.green),
                                  SizedBox(width: 16),
                                  Text('Finish')
                                ],
                              ),
                              onTap: () async {
                                await transactions.put(
                                    ctx, transaction, Status.Finished);
                                redirectToTransactionList();
                              },
                            ),
                          ),
                        ] else ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(_circularRadius),
                              color: Colors.red[50],
                            ),
                            child: ListTile(
                              tileColor: Colors.red[50],
                              title: const Row(
                                children: [
                                  Icon(Icons.close, color: Colors.red),
                                  SizedBox(width: 16),
                                  Text('Reject')
                                ],
                              ),
                              onTap: () async {
                                await transactions.put(
                                    ctx, transaction, Status.Rejected);
                                redirectToTransactionList();
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(_circularRadius),
                              color: Colors.blue[50],
                            ),
                            child: ListTile(
                              // tileColor: Colors.blue[50],
                              title: const Row(
                                children: [
                                  Icon(Icons.check, color: Colors.blue),
                                  SizedBox(width: 16),
                                  Text('Accept')
                                ],
                              ),
                              onTap: () async {
                                await transactions.put(
                                    ctx, transaction, Status.Verified);
                                redirectToTransactionList();
                              },
                            ),
                          )
                        ]
                      ]
                    ],
                  ),
                ),
              );
            }

            return Scaffold(
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
                    trailing: Text(transaction.formattedCreatedAt ?? ''),
                  ),
                  ListTile(
                    leadingAndTrailingTextStyle:
                        Theme.of(context).textTheme.bodyLarge,
                    leading: const Text('Status:'),
                    subtitle: TextButton(
                      onPressed: transaction.status != Status.Finished &&
                              transaction.status != Status.Rejected
                          ? changeStatus
                          : null,
                      child: const Text('Change Status'),
                    ),
                    trailing: statusText(transaction.status!.name),
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
                    trailing: Text(transaction.formattedCreatedAt ?? ''),
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
                    trailing: Text(transaction.formattedVerifiedAt ?? ''),
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
                          transaction.deliveryAddress ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    leadingAndTrailingTextStyle:
                        Theme.of(context).textTheme.bodyLarge,
                    leading: const Text('Total:'),
                    trailing: Text('\$ ${formatNumber(transaction.total!)}'),
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
                  if (transaction.detailTransactions != null &&
                      transaction.detailTransactions!.isNotEmpty)
                    for (var i = 0;
                        i < transaction.detailTransactions!.length;
                        i++)
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(_circularRadius),
                            bottomLeft: Radius.circular(_circularRadius),
                          ),
                          child: Image(
                            image: transaction
                                .detailTransactions![i].car.imageProviderWidget,
                          ),
                        ),
                        title:
                            Text(transaction.detailTransactions![i].car.name),
                        subtitle: Text(
                          '\$ ${formatNumber(transaction.detailTransactions![i].car.price)}',
                        ),
                        trailing: Text(
                          'x ${transaction.detailTransactions![i].qty}',
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      );
    }

    return transactions.when(
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
                    title: Text(data[i].formattedCreatedAt ?? ''),
                    subtitle: statusText(data[i].status!.name),
                    trailing: Text('Total: \$ ${formatNumber(data[i].total!)}'),
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
