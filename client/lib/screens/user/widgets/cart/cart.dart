import 'package:client/components/user_cart_item.dart';
import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/user_transaction.dart';
import 'package:client/providers/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({super.key});

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(userTransactionsProvider);
    String total = '';
    int itemsInCart = 0;

    // select only transactions with status 'OnGoing'
    final onGoingTransactions = cart.asData?.value
        .where((transaction) => transaction.status == Status.OnGoing)
        .toList();

    itemsInCart = onGoingTransactions?.fold(0, (previousValue, element) {
          return (previousValue! + element.detailTransactions!.length);
        }) ??
        0;

    if (onGoingTransactions != null && onGoingTransactions.isNotEmpty) {
      total = formatNumber(
        onGoingTransactions.fold(0, (previousValue, transaction) {
          return previousValue + transaction.total;
        }),
      );
    }

    void openCartScreen() {
      showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cart'),
            ),
            bottomNavigationBar: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(.5),
              ),
              child: Row(
                children: [
                  Text(
                    'Total: \$$total',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  if (onGoingTransactions!.isNotEmpty)
                    for (var transaction in onGoingTransactions)
                      for (var detailTransaction
                          in transaction.detailTransactions!)
                        UserCartItem(detailTransaction: detailTransaction),
                ],
              ),
            ),
          );
        },
      );
    }

    return IconButton(
      onPressed: openCartScreen,
      icon: Badge(
        label: itemsInCart == 0
            ? null
            : Text(itemsInCart.toString()),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
