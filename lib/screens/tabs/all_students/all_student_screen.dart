import 'package:flutter/material.dart';
import 'package:wisdom_management_app/screens/tabs/profile/register_student_screen/register_student.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets /global_drawer/global_drawer.dart';
import 'edit_student_screen/edit_student_screen.dart';

class AllStudentsScreen extends StatelessWidget {
  const AllStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      body: StreamBuilder<List<Student>>(
        stream: firestoreService.getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final students = snapshot.data ?? [];
          if (students.isEmpty) {
            return const Center(child: Text('No students registered yet.'));
          }

          return ListView.builder(
            itemCount: students.length,

            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditStudentScreen(student: student)),
                    );
                  },
                  title: Text(student.name),
                  subtitle: Text("Class: ${student.studentClass}"),
                  trailing: Text(
                    "Joined: ${student.joined.day}/${student.joined.month}/${student.joined.year}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),

      // ✅ Add new student button for admin
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add New Student',
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterStudentScreen()),
          );
          // No need to manually refresh - StreamBuilder listens to changes
        },
      ),
    );
  }
}
