import 'package:client/components/user_cart_item.dart';
import 'package:client/helpers/decimal_formatter.dart';
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
                    .inverseSurface
                    .withOpacity(.2),
              ),
              child: Row(
                children: [
                  Text(
                    'Total: \$${formatNumber(1200000)}',
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
                children: [UserCartItem()],
              ),
            ),
          );
        },
      );
    }

    return IconButton(
      onPressed: openCartScreen,
      icon: const Icon(Icons.shopping_cart),
    );
  }
}
