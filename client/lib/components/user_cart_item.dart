import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/models/user_detail_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCartItem extends ConsumerStatefulWidget {
  const UserCartItem({required this.detailTransaction, super.key});

  final UserDetailTransaction? detailTransaction;

  @override
  ConsumerState<UserCartItem> createState() => _UserCartItemState();
}

class _UserCartItemState extends ConsumerState<UserCartItem> {
  late final num _qty = widget.detailTransaction!.qty;

  late final _qtyController = TextEditingController(text: _qty.toString());

  void addQty() {
    _qtyController.text = (num.parse(_qtyController.text) + 1).toString();
  }

  void substractQty() {
    if (num.parse(_qtyController.text) <= 1) {
      // remove from cart
      return;
    }
    _qtyController.text = (num.parse(_qtyController.text) - 1).toString();
  }

  void setQty(num value) {
    if (value < 1) return;
    _qtyController.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final detailTransaction = widget.detailTransaction;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    CachedNetworkImageProvider(detailTransaction!.car.imageUrl),
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
                  detailTransaction.car.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Price: \$${detailTransaction.carPrice}',
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
              child: Expanded(
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
                        onChanged: (value) => setQty(
                          num.parse(value),
                        ),
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
            ),
          )
        ],
      ),
    );
  }
}