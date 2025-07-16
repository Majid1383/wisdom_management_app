import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/payment_model/payment_model.dart';


class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add new payment for a student
  Future<void> addPayment(PaymentModel payment) async {
    try {
      final docRef = _firestore
          .collection('students')
          .doc(payment.studentId)
          .collection('payments')
          .doc(payment.paymentId);

      await docRef.set(payment.toMap());
      print('✅ Payment added: ${payment.paymentId}');
    } catch (e) {
      print('❌ Failed to add payment: $e');
      rethrow;
    }
  }
}
