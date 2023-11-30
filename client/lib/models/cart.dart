// ignore_for_file: non_constant_identifier_names

import 'package:client/models/cart_item.dart';

class Cart {
  String user_id;
  String formatted_cart_total;
  List<CartItem> carts;

  Cart({
    required this.user_id,
    required this.formatted_cart_total,
    required this.carts,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      user_id: json["id"],
      formatted_cart_total: json["formatted_cart_total"],
      carts: (json["carts"] as List<dynamic>)
          .map((cart) => CartItem.fromJson(cart))
          .toList(),
    );
  }
}
