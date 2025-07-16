import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wisdom_management_app/constants/user_type.dart';
import '../../../../models/holiday_model/holiday_model.dart';
import '../../../../services/holiday_service.dart';
import '../../../../theme/color_manager.dart';


class HolidayDetailPage extends StatefulWidget {
  final String holidayId;
  final UserType userType;

  const HolidayDetailPage({
    super.key,
    required this.holidayId,
    required this.userType,
  });

  @override
  State<HolidayDetailPage> createState() => _HolidayDetailPageState();
}

class _HolidayDetailPageState extends State<HolidayDetailPage> {
  final _holidayService = HolidayService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Holiday>(
      stream: _holidayService.getHolidayById(widget.holidayId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final holiday = snapshot.data!;
        final sortedDates = List<DateTime>.from(holiday.dates)..sort();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Holiday Details'),
            backgroundColor: ColorManager.burntOrange,
            actions: widget.userType == UserType.admin
                ? [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, holiday);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Holiday?'),
                      content: const Text('Are you sure you want to delete this holiday?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _holidayService.deleteHoliday(holiday.id);
                    Navigator.pop(context); // Go back after delete
                  }
                },
              ),
            ]
                : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: ColorManager.lightGrey),
                  ),
                  color: ColorManager.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          holiday.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: ColorManager.darkMint),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                holiday.reason,
                                style: const TextStyle(fontSize: 17, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Dates:',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...sortedDates.map(
                              (date) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: ColorManager.burntOrange, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('EEEE, dd MMM yyyy').format(date),
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Edit dialog to update title & reason
  void _showEditDialog(BuildContext context, Holiday holiday) {
    final titleController = TextEditingController(text: holiday.title);
    final reasonController = TextEditingController(text: holiday.reason);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Holiday'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedHoliday = Holiday(
                id: holiday.id,
                title: titleController.text.trim(),
                reason: reasonController.text.trim(),
                dates: holiday.dates, // keep existing dates
              );
              await _holidayService.updateHoliday(updatedHoliday);
              Navigator.pop(context); // close dialog
              // UI will update automatically thanks to StreamBuilder!
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
