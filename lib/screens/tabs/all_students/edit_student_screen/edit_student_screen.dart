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
  final FirestoreService firestoreService = FirestoreService();

  late String firstName;
  late String? middleName;
  late String lastName;
  late String studentClass;
  late String fatherPhone;
  late String motherPhone;
  late String address;
  late String? parentEmail;

  @override
  void initState() {
    super.initState();
    firstName = widget.student.firstName;
    middleName = widget.student.middleName;
    lastName = widget.student.lastName;
    studentClass = widget.student.studentClass;
    fatherPhone = widget.student.fatherPhone;
    motherPhone = widget.student.motherPhone;
    address = widget.student.address;
    parentEmail = widget.student.parentEmail;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedStudent = widget.student.copyWith(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        studentClass: studentClass,
        fatherPhone: fatherPhone,
        motherPhone: motherPhone,
        address: address,
        parentEmail: parentEmail,
      );

      await firestoreService.updateStudent(updatedStudent);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: firstName,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        onSaved: (v) => firstName = v!.trim(),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: middleName ?? '',
                        decoration: const InputDecoration(labelText: 'Middle Name (optional)'),
                        onSaved: (v) => middleName = v!.trim().isEmpty ? null : v.trim(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: lastName,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        onSaved: (v) => lastName = v!.trim(),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: studentClass,
                        decoration: const InputDecoration(labelText: 'Class'),
                        onSaved: (v) => studentClass = v!.trim(),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: fatherPhone,
                        decoration: const InputDecoration(labelText: "Father's Phone"),
                        keyboardType: TextInputType.phone,
                        onSaved: (v) => fatherPhone = v!.trim(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: motherPhone,
                        decoration: const InputDecoration(labelText: "Mother's Phone"),
                        keyboardType: TextInputType.phone,
                        onSaved: (v) => motherPhone = v!.trim(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: address,
                        decoration: const InputDecoration(labelText: 'Address'),
                        onSaved: (v) => address = v!.trim(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: parentEmail,
                        decoration: const InputDecoration(labelText: 'Parent Email'),
                        onSaved: (v) => parentEmail = v!.trim(),
                        validator: (v) =>
                        v != null && v.isNotEmpty && !v.contains('@') ? 'Invalid email' : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
