import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../constants/user_type.dart';
import '../../../../models/new_student_model/new_student.dart';
import '../../../../services/firestore_service.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final String uuid = Uuid().v4();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  UserType selectedType = UserType.student;

  // Form fields
  String firstName = '';
  String? middleName;
  String lastName = '';
  String school = '';
  String studentClass = '';
  String address = '';
  String parentEmail = '';
  String fatherPhone = '';
  String motherPhone = '';
  double yearlyFeeTarget = 0;
  String? remarks;
  DateTime? dob;
  DateTime? joiningDate;

  // Date picker
  Future<void> _selectDate({
    required DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2010, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateSelected(picked);
  }

  // Save student
  Future<void> _registerStudent() async {
    if (_formKey.currentState!.validate()) {
      if (selectedType == UserType.student && (dob == null || joiningDate == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select DOB and joining date')),
        );
        return;
      }

      _formKey.currentState!.save();

      final newStudent = Student(
        uuid: uuid,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        school: school,
        studentClass: studentClass,
        address: address,
        parentEmail: parentEmail,
        fatherPhone: fatherPhone,
        motherPhone: motherPhone,
        dob: dob!,
        joined: joiningDate!,
        yearlyFeeTarget: yearlyFeeTarget,
        remarks: remarks,
      );

      setState(() => _isLoading = true);
      try {
        await _firestoreService.addStudent(newStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student registered successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding student: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildNameFields() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (v) => v == null || v.isEmpty ? 'Enter first name' : null,
              onSaved: (v) => firstName = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Middle Name (optional)'),
              onSaved: (v) => middleName = v?.trim().isEmpty ?? true ? null : v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (v) => v == null || v.isEmpty ? 'Enter last name' : null,
              onSaved: (v) => lastName = v!.trim(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentFields() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'School'),
              validator: (v) => v == null || v.isEmpty ? 'Enter school' : null,
              onSaved: (v) => school = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Class'),
              validator: (v) => v == null || v.isEmpty ? 'Enter class' : null,
              onSaved: (v) => studentClass = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Complete Address'),
              validator: (v) => v == null || v.isEmpty ? 'Enter address' : null,
              onSaved: (v) => address = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: "Parent's Email"),
              validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
              onSaved: (v) => parentEmail = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: "Father's Phone"),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? 'Enter father\'s phone' : null,
              onSaved: (v) => fatherPhone = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: "Mother's Phone"),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? 'Enter mother\'s phone' : null,
              onSaved: (v) => motherPhone = v!.trim(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Yearly Fee Target'),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Enter yearly fee target' : null,
              onSaved: (v) => yearlyFeeTarget = double.tryParse(v ?? '0') ?? 0,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Remarks (optional)'),
              onSaved: (v) => remarks = v?.trim(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(dob == null
                      ? 'Select Date of Birth'
                      : 'DOB: ${dob!.day}/${dob!.month}/${dob!.year}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(
                      initialDate: dob, onDateSelected: (picked) => setState(() => dob = picked)),
                  child: const Text('Pick'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(joiningDate == null
                      ? 'Select Joining Date'
                      : 'Joined: ${joiningDate!.day}/${joiningDate!.month}/${joiningDate!.year}'),
                ),
                TextButton(
                  onPressed: () => _selectDate(
                      initialDate: joiningDate,
                      onDateSelected: (picked) => setState(() => joiningDate = picked)),
                  child: const Text('Pick'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Student'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('User ID: $uuid', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Register as:'),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Student'),
                    selected: selectedType == UserType.student,
                    onSelected: (_) => setState(() => selectedType = UserType.student),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Admin'),
                    selected: selectedType == UserType.admin,
                    onSelected: (_) => setState(() => selectedType = UserType.admin),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildNameFields(),

              if (selectedType == UserType.student) _buildStudentFields(),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _registerStudent,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Register Student'),
                ),
              ),

              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
