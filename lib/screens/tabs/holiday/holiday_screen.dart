import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/user_type.dart';
import '../../../theme/color_manager.dart';
import '../../../widgets /global_drawer/global_drawer.dart';

class Holiday {
  final String title;
  final List<DateTime> dates;

  Holiday({required this.title, required this.dates});
}

class HolidaysScreen extends StatefulWidget {
  final UserType userType; // 👈 added

  const HolidaysScreen({super.key, required this.userType});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  final List<Holiday> _holidays = [];

  final TextEditingController _titleController = TextEditingController();
  final List<DateTime> _selectedDates = [];

  void _addHoliday() {
    if (_titleController.text.isNotEmpty && _selectedDates.isNotEmpty) {
      setState(() {
        _holidays.add(Holiday(
          title: _titleController.text,
          dates: List.from(_selectedDates),
        ));
        _titleController.clear();
        _selectedDates.clear();
      });
      Navigator.of(context).pop();
    }
  }

  void _showAddHolidayDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Holiday'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Holiday Title'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null && !_selectedDates.contains(picked)) {
                  setState(() => _selectedDates.add(picked));
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick Date'),
            ),
            Wrap(
              spacing: 6,
              children: _selectedDates.map((date) {
                return Chip(
                  label: Text(DateFormat('dd MMM').format(date)),
                  onDeleted: () {
                    setState(() => _selectedDates.remove(date));
                  },
                );
              }).toList(),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addHoliday,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _holidays.sort((a, b) => a.dates.first.compareTo(b.dates.first));

    return Scaffold(
      drawer:  GlobalDrawer(), // You can wrap this with userType check too if needed
      body: _holidays.isEmpty
          ? const Center(child: Text('No holidays added.'))
          : ListView.builder(
        itemCount: _holidays.length,
        itemBuilder: (context, index) {
          final holiday = _holidays[index];
          final dateStr = holiday.dates
              .map((d) => DateFormat('dd MMM').format(d))
              .join(', ');

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: ColorManager.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: ColorManager.lightGrey),
            ),
            child: ListTile(
              leading: Icon(Icons.calendar_month,
                  color: ColorManager.burntOrange),
              title: Text(
                holiday.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(dateStr),
              trailing: Icon(Icons.event_available,
                  color: ColorManager.darkMint),
            ),
          );
        },
      ),
      floatingActionButton: widget.userType == UserType.admin
          ? FloatingActionButton(
        onPressed: _showAddHolidayDialog,
        backgroundColor: ColorManager.burntOrange,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: ColorManager.goldenSand, width: 1),
        ),
        child: const Icon(Icons.add),
        tooltip: 'Add Holiday',
      )
          : null,
    );
  }
}
