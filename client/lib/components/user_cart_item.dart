import 'package:client/models/cart_item.dart';
import 'package:client/providers/user_carts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCartItem extends ConsumerStatefulWidget {
  const UserCartItem({required this.cartItem, super.key});

  final CartItem? cartItem;

  @override
  ConsumerState<UserCartItem> createState() => _UserCartItemState();
}

class _UserCartItemState extends ConsumerState<UserCartItem> {
  final _cartDebounceId = 'cart-debounce';
  late final _qty = widget.cartItem!.quantity;
  late final _cart = ref.read(userCartsProvider.notifier);
  late final _cartItem = widget.cartItem;
  late final _qtyController = TextEditingController(text: _qty.toString());
  late String _prevQty = _qty.toString();

  void _addQty() {
    _qtyController.text = (num.parse(_qtyController.text) + 1).toString();
  }

  void _substractQty() {
    _qtyController.text = (num.parse(_qtyController.text) - 1).toString();
  }

  void _setQty(String value) {
    _qtyController.text = value.toString();
  }

  void _qtyControllerListener() {
    // handle listener when input focused
    if (_prevQty == _qtyController.text) {
      return;
    }
    _prevQty = _qtyController.text;

    final parsedQty = num.tryParse(_qtyController.text) ?? 0;

    EasyDebounce.debounce(
      _cartDebounceId,
      const Duration(milliseconds: 500), // <-- The debounce duration
      () async {
        if (parsedQty < 1) {
          await _cart.delete(context, _cartItem!);
          if (context.mounted) {
            Navigator.pop(context);
            ElegantNotification.success(
              title: const Text('Success'),
              description: const Text('Transaction deleted'),
              background: Theme.of(context).colorScheme.background,
            ).show(context);
          }
        } else {
          _cartItem!.quantity = int.tryParse(_qtyController.text)!;
          await _cart.put(context, _cartItem!);

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
      },
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _qtyController.addListener(_qtyControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _cartItem!.car.imageProviderWidget,
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
                  _cartItem!.car.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Price: \$${_cartItem!.car.formattedPrice}',
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
                      onPressed: _substractQty,
                      icon: const Icon(Icons.remove),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      // enabled: false,
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
                      onChanged: _setQty,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: _addQty,
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
