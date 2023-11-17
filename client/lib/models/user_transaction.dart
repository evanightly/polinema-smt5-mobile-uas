// ignore_for_file: constant_identifier_names

import 'package:client/models/admin.dart';

enum PaymentMethod { Cash, CreditCard, DebitCard }

enum Status { OnGoing, Pending, Rejected, Verified, Finished }

class UserTransaction {
  final String? id;
  final String userId;
  final PaymentMethod paymentMethod;
  final String paymentProof;
  final String paymentDate;
  final String total;
  final Status status;
  final Admin verifiedBy;
  final DateTime verifiedAt;

  const UserTransaction({
    this.id,
    required this.userId,
    required this.paymentMethod,
    required this.paymentProof,
    required this.paymentDate,
    required this.total,
    required this.status,
    required this.verifiedBy,
    required this.verifiedAt,
  });

  factory UserTransaction.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final userId = json['user_id'].toString();
    final paymentMethod = PaymentMethod.values.byName(
      json['payment_method'].toString(),
    );
    final paymentProof = json['payment_proof'].toString();
    final paymentDate = json['payment_date'].toString();
    final total = json['total'].toString();
    final status = Status.values.byName(
      json['status'].toString(),
    );
    final verifiedBy = Admin.fromJson(json['verified_by']);
    final verifiedAt = DateTime.parse(json['status'].toString());

    final userTransaction = UserTransaction(
      id: id,
      userId: userId,
      paymentMethod: paymentMethod,
      paymentProof: paymentProof,
      paymentDate: paymentDate,
      total: total,
      status: status,
      verifiedBy: verifiedBy,
      verifiedAt: verifiedAt,
    );

    return userTransaction;
  }
}
