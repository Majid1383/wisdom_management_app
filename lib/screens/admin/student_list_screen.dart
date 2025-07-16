import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisdom_management_app/screens/tabs/profile/register_student_screen/register_student.dart';
import '../../models/new_student_model/new_student.dart';


class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {

  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }


  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('students');

    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        students = decoded.map((e) => Student.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(students.map((s) => s.toMap()). toList());
    await prefs.setString('students', data);
  }

  Future<void> _addNewStudents() async {
    final newStudent  = await Navigator.push<Student>(
        context,
        MaterialPageRoute(builder: (_) => const RegisterStudentScreen()),
    );

    if (newStudent != null) {
      setState(() {
        students.add(newStudent);
      });
      await _saveStudents();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
      title: const Text('Registered Students'),
      backgroundColor: Colors.deepPurple,
      ),

      body: students.isEmpty ? const Center(child: Text('No students registered yet!'))
            : ListView.builder(
        itemCount: students.length,
          itemBuilder: (context, index) {
          final student  = students[index];
          return Card(
            elevation:  2,
            margin:  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(student.fullName),
              subtitle: Text('Class : ${student.studentClass}'),
              trailing: Text(
                'Joined: ${student.joined.day}/${student.joined.month}/${student.joined.year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
          },
      ),

      floatingActionButton:  FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: _addNewStudents,
        tooltip: 'Add New Students',
        child : const Icon(Icons.add),
      ),
    );
  }
}
