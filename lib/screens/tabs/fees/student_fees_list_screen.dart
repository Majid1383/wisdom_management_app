import 'package:flutter/material.dart';
import 'package:wisdom_management_app/screens/tabs/fees/student_pending_payment_screen.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../services/firestore_service.dart';
import '../../../services/student_service.dart';
import '../../../utils/UserType.dart';


class StudentsFeesListScreen extends StatefulWidget {
  const StudentsFeesListScreen({super.key});

  @override
  State<StudentsFeesListScreen> createState() => _StudentsFeesListScreenState();
}

class _StudentsFeesListScreenState extends State<StudentsFeesListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final StudentService _studentService = StudentService();

  late Future<List<Map<String, dynamic>>> _studentsWithPayments;

  @override
  void initState() {
    super.initState();
    _studentsWithPayments = _fetchStudentsAndPayments();
  }

  Future<List<Map<String, dynamic>>> _fetchStudentsAndPayments() async {
    final students = await _firestoreService.getAllStudents().first;

    List<Map<String, dynamic>> result = [];

    for (var student in students) {
      final payments = await _studentService.getPaymentsForStudent(student.uuid);
      final totalPaid = payments.fold<double>(0, (prev, payment) => prev + payment.amount);
      final due = student.yearlyFeeTarget - totalPaid;

      result.add({
        'student': student,
        'totalPaid': totalPaid,
        'due': due < 0 ? 0 : due,
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Fees'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _studentsWithPayments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final data = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final student = data[index]['student'] as Student;
              final totalPaid = data[index]['totalPaid'] as double;
              final due = data[index]['due'] as double;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    student.firstName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Class: ${student.studentClass}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Paid: ₹${totalPaid.toStringAsFixed(0)}'),
                      Text(
                        'Due: ₹${due.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: due == 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudentPaymentScreen(student: student, userType: UserType.admin),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
