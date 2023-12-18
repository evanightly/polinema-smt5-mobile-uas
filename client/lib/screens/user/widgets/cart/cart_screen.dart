import 'package:client/components/user_cart_item.dart';
import 'package:client/providers/user_carts.dart';
import 'package:client/screens/user/widgets/cart/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    void openCartScreen() {
      void checkout() {
        Navigator.pop(context);
        Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) {
          return const CheckoutScreen();
        }));
      }

      showDialog(
        context: context,
        builder: (context) {
          return Consumer(
            builder: (context, ref, _) {
              final userCarts = ref.watch(userCartsProvider);

              if (userCarts.hasError || userCarts.value == null) {
                return const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.shopping_cart),
                );
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Cart'),
                ),
                body: Container(
                  padding: const EdgeInsets.all(12),
                  child: ListView(
                    children: [
                      // loop carts detail transactions
                      if (userCarts.value!.carts.isNotEmpty)
                        for (final cart in userCarts.value!.carts)
                          UserCartItem(cartItem: cart, key: ValueKey(cart.id)),
                    ],
                  ),
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
                        'Total: \$${userCarts.value!.formattedCartTotal}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            userCarts.value!.carts.isEmpty ? null : checkout,
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    final userCarts = ref.watch(userCartsProvider);

    Widget content = const SizedBox.shrink();

    if (userCarts.value != null) {
      content = IconButton(
        onPressed: openCartScreen,
        icon: userCarts.value!.carts.isNotEmpty
            ? Badge(
                label: Text(userCarts.value!.carts.length.toString()),
                child: const Icon(Icons.shopping_cart),
              )
            : const Icon(Icons.shopping_cart),
      );
    }

    return content;
  }
}
