import 'package:flutter/material.dart';
import 'package:wisdom_management_app/screens/tabs/fees/student_payment_screen.dart';
import '../../../constants/user_type.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../models/payment_model/payment_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/student_service.dart';
// your add payment form screen

class StudentPaymentScreen extends StatefulWidget {
  final Student student;
  final UserType userType;

  const StudentPaymentScreen({
    super.key,
    required this.student,
    required this.userType,
  });

  @override
  State<StudentPaymentScreen> createState() => _StudentPaymentScreenState();
}

class _StudentPaymentScreenState extends State<StudentPaymentScreen> {
  final StudentService _studentService = StudentService();
  UserType? userType;


  late Future<List<PaymentModel>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _studentService.getPaymentsForStudent(widget.student.uuid);
  }


  /// Refresh payments after adding new one
  Future<void> _refreshPayments() async {
    setState(() {
      _paymentsFuture = _studentService.getPaymentsForStudent(widget.student.uuid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: Text('${student.firstName} Payments'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<List<PaymentModel>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final payments = snapshot.data ?? [];

          final totalPaid = payments.fold<double>(0, (sum, p) => sum + p.amount);
          final due = student.yearlyFeeTarget - totalPaid;

          return RefreshIndicator(
            onRefresh: _refreshPayments,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🎉 Summary card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem('Target', '₹${student.yearlyFeeTarget.toStringAsFixed(0)}'),
                        _buildSummaryItem('Paid', '₹${totalPaid.toStringAsFixed(0)}'),
                        _buildSummaryItem(
                          'Due',
                          '₹${due < 0 ? 0 : due.toStringAsFixed(0)}',
                          color: due <= 0 ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📌 Payment history title
                const Text(
                  'Payment History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // 📝 List of payments
                if (payments.isEmpty)
                  const Text('No payments yet.')
                else
                  ...payments.map((p) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.payment),
                      title: Text('₹${p.amount.toStringAsFixed(0)}'),
                      // subtitle: Text(
                      //   '${p.method.name} | ${p.notes ?? 'No notes'}',
                      // ),
                      trailing: Text(
                        _formatDate(p.paymentDate),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )),
              ],
            ),
          );
        },
      ),

      // ➕ FAB to add payment
      floatingActionButton: userType == UserType.admin
          ? FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentScreen(student: student),
            ),
          );
          if (added == true) {
            _refreshPayments();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
      )
          : null,

    );
  }

  /// Helper: build summary item widget
  Widget _buildSummaryItem(String title, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Helper: format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
