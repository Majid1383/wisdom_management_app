import 'package:flutter/material.dart';
import 'package:wisdom_management_app/screens/tabs/fees/student_payment_screen.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../models/payment_model/payment_model.dart';
import '../../../services/student_service.dart';
import '../../../utils/UserType.dart';

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

  late Future<List<PaymentModel>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _studentService.getPaymentsForStudent(widget.student.uuid);
  }

  Future<void> _refreshPayments() async {
    setState(() {
      _paymentsFuture = _studentService.getPaymentsForStudent(widget.student.uuid);
    });
  }

  bool isRecent(DateTime date) => DateTime.now().difference(date).inDays <= 7;

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(

      body: FutureBuilder<List<PaymentModel>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
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

                // 🪄 Floating title card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.blue.shade50,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Center(
                      child: Text(
                        '${student.firstName} Payments',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),


                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.blue.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSummaryItem('🎯 Target', '₹${student.yearlyFeeTarget.toStringAsFixed(0)}'),
                        _buildSummaryItem('✅ Paid', '₹${totalPaid.toStringAsFixed(0)}', color: Colors.green),
                        _buildSummaryItem(
                          '⚠️ Due',
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),

                // 📝 List of payments
                if (payments.isEmpty)
                  const Center(
                    child: Text('No payments yet.', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...payments.map((p) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isRecent(p.paymentDate) ? Colors.green.shade100 : Colors.blue.shade100,
                        child: const Icon(Icons.currency_rupee, color: Colors.blue),
                      ),
                      title: Text(
                        '₹${p.amount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        _formatDate(p.paymentDate),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                    ),
                  )),
              ],
            ),
          );
        },
      ),

      // ➕ FAB to add payment only if userType == admin
      floatingActionButton: widget.userType == UserType.admin
          ? FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentScreen(student: widget.student),
            ),
          );
          if (added == true) {
            _refreshPayments();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue.shade700,
        elevation: 3,
      )
          : null,
    );
  }

  Widget _buildSummaryItem(String title, String value, {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}




