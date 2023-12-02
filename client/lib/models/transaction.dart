// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:io';

import 'package:client/models/admin.dart';
import 'package:client/models/detail_transaction.dart';
import 'package:flutter/material.dart';

enum PaymentMethod { Cash, CreditCard, DebitCard }

enum Status { Pending, Rejected, Verified, Finished }

class Transaction {
  final int? id;
  final String userId;
  final PaymentMethod? paymentMethod;
  final String? paymentProof;
  final String? paymentDate;
  final num total;
  final Status status;
  final Admin? verifiedBy;
  final DateTime? verifiedAt;
  final DateTime createdAt;
  final String? deliveryAddress;
  final String? paymentProofUrl;
  final String? formattedCreatedAt;
  final String? formattedVerifiedAt;
  final String? formattedTotal;
  final File? uploadPaymentProof;

  final List<DetailTransaction>? detailTransactions;

  const Transaction({
    this.id,
    required this.userId,
    this.paymentMethod,
    this.paymentProof,
    this.paymentDate,
    required this.total,
    required this.status,
    this.verifiedBy,
    this.verifiedAt,
    required this.createdAt,
    this.deliveryAddress,
    this.paymentProofUrl,
    this.formattedCreatedAt,
    this.formattedVerifiedAt,
    this.formattedTotal,
    this.detailTransactions,
    this.uploadPaymentProof,
  });

  ImageProvider get imageProviderWidget {
    if (paymentProofUrl == null) {
      return const AssetImage('assets/images/car1_MustangGT.jpg');
    }
    return NetworkImage(paymentProofUrl!);
  }

  factory Transaction.fromJson(dynamic json) {
    final parsedPaymentMethod = json['payment_method'] != null
        ? PaymentMethod.values.byName(json['payment_method'])
        : null;

    final parsedVerifiedBy = json['verified_by'] != null
        ? Admin.fromJson(json['verified_by'])
        : null;

    final parsedVerifiedAt = json['verified_at'] != null
        ? DateTime.tryParse(json['verified_at'])
        : null;

    final parsedDetailTransactions = json['detail_transactions'] != null
        ? (json['detail_transactions'] as List<dynamic>)
            .map((e) => DetailTransaction.fromJson(e))
            .toList()
        : null;

    final id = json['id'];
    final userId = json['user_id'];
    final paymentMethod = parsedPaymentMethod;
    final paymentProof = json['payment_proof'];
    final paymentDate = json['payment_date'];
    final total = json['total'];
    final status = Status.values.byName(json['status']);
    final verifiedBy = parsedVerifiedBy;
    final verifiedAt = parsedVerifiedAt;
    final createdAt = DateTime.parse(json['created_at']);
    final deliveryAddress = json['delivery_address'];
    final paymentProofUrl = json['payment_proof_url'];
    final formattedCreatedAt = json['formatted_created_at'];
    final formattedVerifiedAt = json['formatted_verified_at'];
    final formattedTotal = json['formatted_total'];
    final detailTransactions = parsedDetailTransactions;

    final userTransaction = Transaction(
      id: id,
      userId: userId,
      paymentMethod: paymentMethod,
      paymentProof: paymentProof,
      paymentDate: paymentDate,
      total: total,
      status: status,
      verifiedBy: verifiedBy,
      verifiedAt: verifiedAt,
      createdAt: createdAt,
      deliveryAddress: deliveryAddress,
      paymentProofUrl: paymentProofUrl,
      formattedCreatedAt: formattedCreatedAt,
      formattedVerifiedAt: formattedVerifiedAt,
      formattedTotal: formattedTotal,
      detailTransactions: detailTransactions,
    );

    return userTransaction;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'payment_method': paymentMethod?.name,
      'payment_proof': paymentProof,
      'payment_date': paymentDate,
      'total': total,
      'status': status.name,
      'verified_by': verifiedBy?.toJson(),
      'verified_at': verifiedAt.toString(),
      'created_at': createdAt.toString(),
      'delivery_address': deliveryAddress,
      'payment_proof_url': paymentProofUrl,
      'formatted_created_at': formattedCreatedAt,
      'formatted_verified_at': formattedVerifiedAt,
      'formatted_total': formattedTotal,
      'detail_transactions':
          detailTransactions?.map((e) => e.toJson()).toList(),
      'upload_payment_proof': uploadPaymentProof,
    };
  }
}
