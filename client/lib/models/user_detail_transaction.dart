import 'package:client/models/car.dart';

class UserDetailTransaction {
  final String id;
  final String transactionId;
  final String carId;
  final num carPrice;
  final String qty;
  final num subtotal;
  final Car car;

  const UserDetailTransaction({
    required this.id,
    required this.transactionId,
    required this.carId,
    required this.carPrice,
    required this.qty,
    required this.subtotal,
    required this.car,
  });

  factory UserDetailTransaction.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final transactionId = json['transaction_id'].toString();
    final carId = json['car_id'].toString();
    final carPrice = json['car']['price'];
    final qty = json['qty'].toString();
    final subtotal = json['subtotal'];
    final car = Car.fromJson(json['car']);

    return UserDetailTransaction(
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
