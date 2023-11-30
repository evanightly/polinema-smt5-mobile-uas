// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';

import 'package:client/models/admin.dart';
import 'package:client/models/detail_transaction.dart';
import 'package:flutter/material.dart';

enum PaymentMethod { Cash, CreditCard, DebitCard }

enum Status { OnGoing, Pending, Rejected, Verified, Finished }

class Transaction {
  final int? id;
  final String user_id;
  final PaymentMethod? payment_method;
  final String? payment_proof;
  final String? payment_date;
  final num total;
  final Status status;
  final Admin? verified_by;
  final DateTime? verified_at;
  final DateTime created_at;
  final String? delivery_address;
  final String? payment_proof_url;
  final String? formatted_created_at;
  final String? formatted_verified_at;
  final String? formatted_total;
  final File? upload_payment_proof;

  final List<DetailTransaction>? detail_transactions;

  const Transaction({
    this.id,
    required this.user_id,
    this.payment_method,
    this.payment_proof,
    this.payment_date,
    required this.total,
    required this.status,
    this.verified_by,
    this.verified_at,
    required this.created_at,
    this.delivery_address,
    this.payment_proof_url,
    this.formatted_created_at,
    this.formatted_verified_at,
    this.formatted_total,
    this.detail_transactions,
    this.upload_payment_proof,
  });

  // get transactionDate => created_at.toString().split(' ')[0];
  // get verifiedDate => verified_at.toString().split(' ')[0];
  // get formattedTotal => formatNumber(total);

  ImageProvider get imageProviderWidget {
    if (payment_proof_url == null) {
      return const AssetImage('assets/images/car1_MustangGT.jpg');
    }
    return NetworkImage(payment_proof_url!);
  }

  factory Transaction.fromJson(dynamic json) {
    try {
      final id = json['id'];
      final user_id = json['user_id'];
      final payment_method = json['payment_method'] != null
          ? PaymentMethod.values.byName(json['payment_method'])
          : null;
      final payment_proof = json['payment_proof'];
      final payment_date = json['payment_date'];
      final total = json['total'];
      final status = Status.values.byName(json['status']);
      final verified_by = json['verified_by'] != null
          ? Admin.fromJson(json['verified_by'])
          : null;
      final verified_at = json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'])
          : null;
      final created_at = DateTime.parse(json['created_at']);
      final delivery_address = json['delivery_address'];
      final payment_proof_url = json['payment_proof_url'];
      final formatted_created_at = json['formatted_created_at'];
      final formatted_verified_at = json['formatted_verified_at'];
      final formatted_total = json['formatted_total'];
      final detail_transactions =
          (json['detail_transactions'] as List<dynamic>).map(
        (detailTransaction) {
          return DetailTransaction.fromJson(detailTransaction);
        },
      ).toList();
      final userTransaction = Transaction(
        id: id,
        user_id: user_id,
        payment_method: payment_method,
        payment_proof: payment_proof,
        payment_date: payment_date,
        total: total,
        status: status,
        verified_by: verified_by,
        verified_at: verified_at,
        created_at: created_at,
        delivery_address: delivery_address,
        payment_proof_url: payment_proof_url,
        formatted_created_at: formatted_created_at,
        formatted_verified_at: formatted_verified_at,
        formatted_total: formatted_total,
        detail_transactions: detail_transactions,
      );

      return userTransaction;
    } catch (e) {
      // print(e);
      throw Exception('Failed to parse UserTransaction from JSON');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'payment_method': payment_method?.name,
      'payment_proof': payment_proof,
      'payment_date': payment_date,
      'total': total,
      'status': status.name,
      'verified_by': verified_by?.toJson(),
      'verified_at': verified_at.toString(),
      'created_at': created_at.toString(),
      'delivery_address': delivery_address,
      'payment_proof_url': payment_proof_url,
      'formatted_created_at': formatted_created_at,
      'formatted_verified_at': formatted_verified_at,
      'formatted_total': formatted_total,
      'detail_transactions':
          detail_transactions?.map((e) => e.toJson()).toList(),
      'upload_payment_proof': upload_payment_proof,
    };
  }

  // try {
  //   print('JSON');
  //   print(json);
  //   final id = json['id'].toString();
  //   final userId = json['user_id'].toString();
  //   final paymentMethod = PaymentMethod.values.byName(
  //     json['payment_method'].toString(),
  //   );
  //   final paymentProof = json['payment_proof'].toString();
  //   final paymentDate = json['payment_date'].toString();
  //   final total = json['total'].toString();
  //   final status = Status.values.byName(
  //     json['status'].toString(),
  //   );
  //   final verifiedBy = Admin.fromJson(json['verified_by']);
  //   final verifiedAt = DateTime.parse(json['status'].toString());
  //   final createdAt = DateTime.parse(json['created_at'].toString());

  //   final userTransaction = UserTransaction(
  //     id: id,
  //     userId: userId,
  //     paymentMethod: paymentMethod,
  //     paymentProof: paymentProof,
  //     paymentDate: paymentDate,
  //     total: total,
  //     status: status,
  //     verifiedBy: verifiedBy,
  //     verifiedAt: verifiedAt,
  //     createdAt: createdAt,
  //   );

  //   return userTransaction;
  // } catch (e) {
  //   print(e);
  // }
}
