import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../constants/user_type.dart';
import '../../../../models/new_student_model/new_student.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final String uuid = Uuid().v4();

  // User type toggle
  UserType selectedType = UserType.student;

  // Form fields
  String fullName = '';
  String school = '';
  String studentClass = '';
  String address = '';
  String fatherPhone = '';
  String motherPhone = '';
  DateTime? dob;
  DateTime? joiningDate;

  // Helper: open date picker
  Future<void> _selectDate({
    required BuildContext context,
    required DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2015, 1, 1),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New User'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: $uuid',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 16),

              // Toggle between Student / Admin
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Register as:'),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Student'),
                    selected: selectedType == UserType.student,
                    onSelected: (_) {
                      setState(() => selectedType = UserType.student);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Admin'),
                    selected: selectedType == UserType.admin,
                    onSelected: (_) {
                      setState(() => selectedType = UserType.admin);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter full name' : null,
                onSaved: (value) => fullName = value!,
              ),

              if (selectedType == UserType.student) ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'School'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter school' : null,
                  onSaved: (value) => school = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Class'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter class' : null,
                  onSaved: (value) => studentClass = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Complete Address'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
                  onSaved: (value) => address = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Father's Phone"),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Enter father\'s phone' : null,
                  onSaved: (value) => fatherPhone = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Mother's Phone"),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Enter mother\'s phone' : null,
                  onSaved: (value) => motherPhone = value!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dob == null
                            ? 'Select Date of Birth'
                            : 'DOB: ${dob!.day}/${dob!.month}/${dob!.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _selectDate(
                          context: context,
                          initialDate: dob,
                          onDateSelected: (picked) {
                            setState(() => dob = picked);
                          },
                        );
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        joiningDate == null
                            ? 'Select Date of Joining'
                            : 'Joined: ${joiningDate!.day}/${joiningDate!.month}/${joiningDate!.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _selectDate(
                          context: context,
                          initialDate: joiningDate,
                          onDateSelected: (picked) {
                            setState(() => joiningDate = picked);
                          },
                        );
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedType == UserType.student &&
                          (dob == null || joiningDate == null)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select DOB and joining date')),
                        );
                        return;
                      }
                      _formKey.currentState!.save();

                      final newStudent = Student(
                        uuid: uuid,
                        name: fullName,
                        school: school,
                        studentClass: studentClass,
                        address: address,
                        fatherPhone: fatherPhone,
                        motherPhone: motherPhone,
                        dob: dob ?? DateTime.now(),
                        joined: joiningDate ?? DateTime.now(),
                        type: selectedType,
                      );

                      Navigator.pop(context, newStudent);
                    }
                  },
                  child: const Text('Register User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
