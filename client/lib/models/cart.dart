// ignore_for_file: non_constant_identifier_names

import 'package:client/models/cart_item.dart';

class Cart {
  String userId;
  String formattedCartTotal;
  List<CartItem> carts;

  Cart({
    required this.userId,
    required this.formattedCartTotal,
    required this.carts,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final List<CartItem> parsedCarts = json['carts'] != null
        ? (json['carts'] as List<dynamic>).map(
            (cart) {
              return CartItem.fromJson(cart);
            },
          ).toList()
        : [];

    return Cart(
      userId: json["id"],
      formattedCartTotal: json["formatted_cart_total"],
      carts: parsedCarts,
    );
  }
}
