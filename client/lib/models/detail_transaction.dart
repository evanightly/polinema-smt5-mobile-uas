// ignore_for_file: non_constant_identifier_names

import 'package:client/helpers/decimal_formatter.dart';
import 'package:client/models/car.dart';

class DetailTransaction {
  final int id;
  final int transactionId;
  final int carId;
  final num carPrice;
  final int qty;
  final num subtotal;
  final Car car;

  const DetailTransaction({
    required this.id,
    required this.transactionId,
    required this.carId,
    required this.carPrice,
    required this.qty,
    required this.subtotal,
    required this.car,
  });

  get formattedCarPrice => formatNumber(carPrice);
  get formattedSubtotal => formatNumber(subtotal);

  factory DetailTransaction.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final transactionId = json['transaction_id'];
    final carId = json['car_id'];
    final carPrice = json['car_price'];
    final qty = json['qty'];
    final subtotal = json['subtotal'];
    final car = Car.fromJson(json['car']);

    return DetailTransaction(
      id: id,
      transactionId: transactionId,
      carId: carId,
      carPrice: carPrice,
      qty: qty,
      subtotal: subtotal,
      car: car,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'car_id': carId,
      'car_price': carPrice,
      'qty': qty,
      'subtotal': subtotal,
      'car': car.toJson(),
    };
  }
}
