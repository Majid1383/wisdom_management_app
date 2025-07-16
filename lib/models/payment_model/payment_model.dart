import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/PaymentMethod.dart';

class PaymentModel {
  final String paymentId;         // unique doc ID from Firestore
  final String studentId;         // reference to student
  final double amount;
  final DateTime paymentDate;
  final PaymentMethod paymentMethod;
  final String? transactionId;    // optional
  final String? notes;            // optional
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentModel({
    required this.paymentId,
    required this.studentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.transactionId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert PaymentModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'studentId': studentId,
      'amount': amount,
      'paymentDate': Timestamp.fromDate(paymentDate),
      'paymentMethod': paymentMethod.name, // store as string
      'transactionId': transactionId,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create PaymentModel from Firestore document
  factory PaymentModel.fromMap(Map<String, dynamic> map, String docId) {
    return PaymentModel(
      paymentId: docId,
      studentId: map['studentId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentDate: (map['paymentDate'] as Timestamp).toDate(),
      paymentMethod: PaymentMethodExtension.fromString(map['paymentMethod'] ?? 'cash'),
      transactionId: map['transactionId'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
