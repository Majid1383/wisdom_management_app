import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../models/payment_model/payment_model.dart';
import '../../../services/payment_service.dart';
import '../../../utils/PaymentMethod.dart';

class PaymentScreen extends StatefulWidget {
  final Student student;

  const PaymentScreen({super.key, required this.student });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final PaymentService _paymentService = PaymentService();

  bool _paymentAdded = false;

  bool _isLoading = false;

  double? amount;
  DateTime? paidDate;
  PaymentMethod mode = PaymentMethod.cash; // default
  String? notes;

  // Date picker helper
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => paidDate = picked);
    }
  }

  Future<void> _savePayment() async {
    if (_formKey.currentState!.validate()) {
      if (paidDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select paid date')),
        );
        return;
      }

      _formKey.currentState!.save();

      final now = DateTime.now();
      final payment = PaymentModel(
        paymentId: const Uuid().v4(),
        studentId: widget.student.uuid,
        amount: amount!,
        paymentDate: paidDate!,
        paymentMethod: mode,
        transactionId: null,   // optional, for now
        notes: notes ?? '',
        createdAt: now,
        updatedAt: now,
      );


      setState(() => _isLoading = true);
      try {
        await _paymentService.addPayment(payment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment added!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // return true to refresh
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Student: ${widget.student.firstName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter amount' : null,
                onSaved: (v) => amount = double.tryParse(v ?? ''),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      paidDate == null
                          ? 'Select Paid Date'
                          : 'Paid: ${paidDate!.day}/${paidDate!.month}/${paidDate!.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<PaymentMethod>(
                value: mode,
                items: PaymentMethod.values.map((pm) {
                  return DropdownMenuItem(
                    value: pm,
                    child: Text(pm.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (v) => setState(() => mode = v!),
                decoration: const InputDecoration(labelText: 'Payment Mode'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                onSaved: (v) => notes = v,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Save Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
