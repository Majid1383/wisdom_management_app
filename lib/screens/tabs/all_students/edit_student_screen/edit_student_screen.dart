import 'package:flutter/material.dart';
import '../../../../models/new_student_model/new_student.dart';
import '../../../../services/firestore_service.dart';


class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String studentClass;
  late String fatherPhone;
  late String motherPhone;
  late String address;
  late String? parentEmail;

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    name = widget.student.name;
    studentClass = widget.student.studentClass;
    fatherPhone = widget.student.fatherPhone;
    motherPhone = widget.student.motherPhone;
    address = widget.student.address;
    parentEmail = widget.student.parentEmail;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = widget.student.copyWith(
        name: name,
        studentClass: studentClass,
        fatherPhone: fatherPhone,
        motherPhone: motherPhone,
        address: address,
        parentEmail: parentEmail,
      );

      await firestoreService.updateStudent(updatedStudent);

      if (!mounted) return;
      Navigator.pop(context); // go back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                initialValue: studentClass,
                decoration: const InputDecoration(labelText: 'Class'),
                onChanged: (value) => studentClass = value,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                initialValue: fatherPhone,
                decoration: const InputDecoration(labelText: 'Father\'s Phone'),
                onChanged: (value) => fatherPhone = value,
              ),
              TextFormField(
                initialValue: motherPhone,
                decoration: const InputDecoration(labelText: 'Mother\'s Phone'),
                onChanged: (value) => motherPhone = value,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
              ),
              TextFormField(
                initialValue: parentEmail,
                decoration: const InputDecoration(labelText: 'Parent Email'),
                onChanged: (value) => parentEmail = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
