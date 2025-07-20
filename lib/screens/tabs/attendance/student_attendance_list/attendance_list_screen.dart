import 'package:flutter/material.dart';
import 'package:wisdom_management_app/models/new_student_model/new_student.dart';
import 'package:wisdom_management_app/screens/tabs/attendance/attendance_calendar.dart';
import '../../../../services/firestore_service.dart';
import '../../../../theme/color_manager.dart';
import '../../../../utils/UserType.dart';

class AttendanceListScreen extends StatelessWidget {
  final UserType userType;

  const AttendanceListScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightCoolGrey,
      body: StreamBuilder<List<Student>>(
        stream: FirestoreService().getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: ColorManager.tealAccent));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final students = snapshot.data ?? [];

          if (students.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                color: ColorManager.charcoalGray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ColorManager.tealAccent,
                    child: Text(
                      student.firstName.isNotEmpty ? student.firstName[0] : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    student.fullName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Class: ${student.studentClass ?? '-'}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttendanceCalendarScreen(
                          students: [student],  // or: students: [student],
                          userType: userType,
                        ),
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
