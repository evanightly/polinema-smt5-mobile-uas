import 'package:client/models/cart_item.dart';
import 'package:client/providers/user_carts.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCartItem extends ConsumerStatefulWidget {
  const UserCartItem({required this.cartItem, required this.ref, super.key});

  final CartItem? cartItem;
  final WidgetRef ref;

  @override
  ConsumerState<UserCartItem> createState() => _UserCartItemState();
}

class _UserCartItemState extends ConsumerState<UserCartItem> {
  late final num _qty = widget.cartItem!.quantity;

  late final _qtyController = TextEditingController(text: _qty.toString());

  void addQty() {
    _qtyController.text = (num.parse(_qtyController.text) + 1).toString();
  }

  void substractQty() {
    _qtyController.text = (num.parse(_qtyController.text) - 1).toString();
  }

  void setQty(String value) {
    _qtyController.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ref = widget.ref;
    final cart = ref.read(userCartsProvider.notifier);
    final cartItem = widget.cartItem;

    _qtyController.addListener(() async {
      final parsedQty = num.tryParse(_qtyController.text) ?? 0;
      if (parsedQty < 1) {
        await cart.delete(context, cartItem!);
        if (context.mounted) {
          Navigator.pop(context);
          ElegantNotification.success(
            title: const Text('Success'),
            description: const Text('Transaction deleted'),
            background: Theme.of(context).colorScheme.background,
          ).show(context);
        }
      } else {
        cartItem!.quantity = int.tryParse(_qtyController.text)!;
        await cart.put(context, cartItem);

        // if (context.mounted) {
        //   ElegantNotification.success(
        //     title: const Text("Success"),
        //     description: Text(
        //       "${widget.cartItem!.car.name} quantity has been updated",
        //     ),
        //     background: Theme.of(context).colorScheme.background,
        //   ).show(context);
        // }
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: cartItem!.car.imageProviderWidget,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.car.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Price: \$${cartItem.car.formattedPrice}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: substractQty,
                      icon: const Icon(Icons.remove),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      enabled: false,
                      controller: _qtyController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 0,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: setQty,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: addQty,
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
