// ignore_for_file: non_constant_identifier_names

import 'package:client/models/car.dart';

class CartItem {
  int id;
  Car car;
  int quantity;
  String formattedSubtotal;

  CartItem({
    required this.id,
    required this.car,
    required this.quantity,
    required this.formattedSubtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json["id"],
      car: Car.fromJson(json["car"]),
      quantity: json["quantity"],
      formattedSubtotal: json["formatted_subtotal"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
    };
  }
}
