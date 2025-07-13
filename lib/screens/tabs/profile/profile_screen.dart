import 'package:flutter/material.dart';
import '../../../models/new_student_model/new_student.dart' show Student;
import '../../login/login_screen.dart';


class ProfileScreen extends StatelessWidget {
  final Student student;

  const ProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Avatar & name
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    student.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  Text(
                    'Class: ${student.studentClass}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            // Profile details
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.deepPurple),
                title: const Text('School'),
                subtitle: Text(student.school),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                title: const Text('Date of Birth'),
                subtitle: Text('${student.dob.day}/${student.dob.month}/${student.dob.year}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.date_range, color: Colors.deepPurple),
                title: const Text('Joined Date'),
                subtitle: Text('${student.joined.day}/${student.joined.month}/${student.joined.year}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.deepPurple),
                title: const Text('Father\'s Phone'),
                subtitle: Text(student.fatherPhone),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.deepPurple),
                title: const Text('Mother\'s Phone'),
                subtitle: Text(student.motherPhone),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.home, color: Colors.deepPurple),
                title: const Text('Address'),
                subtitle: Text(student.address),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.deepPurple),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false, // remove all previous routes
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
