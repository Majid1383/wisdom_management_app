import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model/payment_model.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PaymentModel>> getPaymentsForStudent(String studentId) async {
    final snapshot = await _firestore
        .collection('students')
        .doc(studentId)
        .collection('payments')
        .orderBy('paymentDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PaymentModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
