// ignore_for_file: non_constant_identifier_names

import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';

class UserDetailTransaction {
  final String id;
  final String transaction_id;
  final String car_id;
  final num car_price;
  final int qty;
  final num subtotal;
  final Car car;

  const UserDetailTransaction({
    required this.id,
    required this.transaction_id,
    required this.car_id,
    required this.car_price,
    required this.qty,
    required this.subtotal,
    required this.car,
  });

  get formattedCarPrice => formatNumber(car_price);
  get formattedSubtotal => formatNumber(subtotal);

  factory UserDetailTransaction.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final transaction_id = json['transaction_id'].toString();
    final car_id = json['car_id'].toString();
    final car_price = json['car_price'];
    final qty = json['qty'];
    final subtotal = json['subtotal'];
    final car = Car.fromJson(json['car']);

    return UserDetailTransaction(
      id: id,
      transaction_id: transaction_id,
      car_id: car_id,
      car_price: car_price,
      qty: qty,
      subtotal: subtotal,
      car: car,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transaction_id,
      'car_id': car_id,
      'car_price': car_price,
      'qty': qty,
      'subtotal': subtotal,
      'car': car.toJson(),
    };
  }
}
