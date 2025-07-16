// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../constants/user_type.dart';
// import '../../../theme/color_manager.dart';
// import '../../../widgets /global_drawer/global_drawer.dart';
//
// class Holiday {
//   final String title;
//   final List<DateTime> dates;
//
//   Holiday({required this.title, required this.dates});
// }
//
// class HolidaysScreen extends StatefulWidget {
//   final UserType userType; // 👈 added
//
//   const HolidaysScreen({super.key, required this.userType});
//
//   @override
//   State<HolidaysScreen> createState() => _HolidaysScreenState();
// }
//
// class _HolidaysScreenState extends State<HolidaysScreen> {
//   final List<Holiday> _holidays = [];
//
//   final TextEditingController _titleController = TextEditingController();
//   final List<DateTime> _selectedDates = [];
//
//   void _addHoliday() {
//     if (_titleController.text.isNotEmpty && _selectedDates.isNotEmpty) {
//       setState(() {
//         _holidays.add(Holiday(
//           title: _titleController.text,
//           dates: List.from(_selectedDates),
//         ));
//         _titleController.clear();
//         _selectedDates.clear();
//       });
//       Navigator.of(context).pop();
//     }
//   }
//
//   void _showAddHolidayDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Add Holiday'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: 'Holiday Title'),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2024),
//                   lastDate: DateTime(2030),
//                 );
//                 if (picked != null && !_selectedDates.contains(picked)) {
//                   setState(() => _selectedDates.add(picked));
//                 }
//               },
//               icon: const Icon(Icons.calendar_today),
//               label: const Text('Pick Date'),
//             ),
//             Wrap(
//               spacing: 6,
//               children: _selectedDates.map((date) {
//                 return Chip(
//                   label: Text(DateFormat('dd MMM').format(date)),
//                   onDeleted: () {
//                     setState(() => _selectedDates.remove(date));
//                   },
//                 );
//               }).toList(),
//             )
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: _addHoliday,
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _holidays.sort((a, b) => a.dates.first.compareTo(b.dates.first));
//
//     return Scaffold(
//       drawer:  GlobalDrawer(), // You can wrap this with userType check too if needed
//       body: _holidays.isEmpty
//           ? const Center(child: Text('No holidays added.'))
//           : ListView.builder(
//         itemCount: _holidays.length,
//         itemBuilder: (context, index) {
//           final holiday = _holidays[index];
//           final dateStr = holiday.dates
//               .map((d) => DateFormat('dd MMM').format(d))
//               .join(', ');
//
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: ColorManager.white,
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: ColorManager.lightGrey),
//             ),
//             child: ListTile(
//               leading: Icon(Icons.calendar_month,
//                   color: ColorManager.burntOrange),
//               title: Text(
//                 holiday.title,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(dateStr),
//               trailing: Icon(Icons.event_available,
//                   color: ColorManager.darkMint),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: widget.userType == UserType.admin
//           ? FloatingActionButton(
//         onPressed: _showAddHolidayDialog,
//         backgroundColor: ColorManager.burntOrange,
//         foregroundColor: Colors.white,
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100),
//           side: BorderSide(color: ColorManager.goldenSand, width: 1),
//         ),
//         child: const Icon(Icons.add),
//         tooltip: 'Add Holiday',
//       )
//           : null,
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../constants/user_type.dart';
// import '../../../models/holiday_model/holiday_model.dart';
// import '../../../theme/color_manager.dart';
//
//
// class HolidaysScreen extends StatefulWidget {
//   final UserType userType;
//
//   const HolidaysScreen({super.key, required this.userType});
//
//   @override
//   State<HolidaysScreen> createState() => _HolidaysScreenState();
// }
//
// class _HolidaysScreenState extends State<HolidaysScreen> {
//
//   final TextEditingController _titleController = TextEditingController();
//
//   final HolidayService _holidayService = HolidayService();
//   final TextEditingController _reasonController = TextEditingController();
//
//
//   final List<DateTime> _selectedDates = [];
//
//   void _addHoliday() async {
//     final title = _titleController.text.trim();
//     final reason = _reasonController.text.trim();
//
//     if (title.isEmpty || reason.isEmpty || _selectedDates.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill title, reason, and pick dates')),
//       );
//       return;
//     }
//
//     final holiday = Holiday(
//       title: title,
//       dates: List.from(_selectedDates),
//       reason: reason,
//     );
//
//     await _holidayService.addHoliday(holiday);
//
//     _titleController.clear();
//     _reasonController.clear();
//     setState(() => _selectedDates.clear());
//
//     Navigator.of(context).pop();
//   }
//
//
//   void _showAddHolidayDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Add Holiday'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: 'Holiday Title'),
//               ),
//
//               const SizedBox(height: 12),
//
//               TextField(
//                 controller: _reasonController,
//                 decoration: const InputDecoration(labelText: 'Reason for Holiday'),
//               ),
//
//
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2024),
//                     lastDate: DateTime(2030),
//                   );
//                   if (picked != null && !_selectedDates.contains(picked)) {
//                     setState(() => _selectedDates.add(picked));
//                   }
//                 },
//                 icon: const Icon(Icons.calendar_today),
//                 label: const Text('Pick Date (can pick multiple)'),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 6,
//                 children: _selectedDates.map((date) {
//                   return Chip(
//                     label: Text(DateFormat('dd MMM').format(date)),
//                     onDeleted: () {
//                       setState(() => _selectedDates.remove(date));
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: _addHoliday,
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _holidays.sort((a, b) => a.dates.first.compareTo(b.dates.first));
//
//     return Scaffold(
//       body: _holidays.isEmpty
//           ? const Center(child: Text('No holidays added.'))
//           : ListView.builder(
//         itemCount: _holidays.length,
//         itemBuilder: (context, index) {
//           final holiday = _holidays[index];
//           final dateStr = holiday.dates
//               .map((d) => DateFormat('dd MMM').format(d))
//               .join(', ');
//
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: ColorManager.white,
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//               side: BorderSide(color: ColorManager.lightGrey),
//             ),
//             child: ListTile(
//               leading: Icon(Icons.calendar_month, color: ColorManager.burntOrange),
//               title: Text(
//                 holiday.title,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(dateStr),
//               trailing: Icon(Icons.event_available, color: ColorManager.darkMint),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: widget.userType == UserType.admin
//           ? FloatingActionButton(
//         onPressed: _showAddHolidayDialog,
//         backgroundColor: ColorManager.burntOrange,
//         foregroundColor: Colors.white,
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100),
//           side: BorderSide(color: ColorManager.goldenSand, width: 1),
//         ),
//         child: const Icon(Icons.add),
//         tooltip: 'Add Holiday',
//       )
//           : null,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/user_type.dart';
import '../../../models/holiday_model/holiday_model.dart';
import '../../../services/holiday_service.dart';
import '../../../theme/color_manager.dart';
import 'detailed_holiday_screen/detailed_holiday_screen.dart';


class HolidaysScreen extends StatefulWidget {
  final UserType userType;

  const HolidaysScreen({super.key, required this.userType});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  final HolidayService _holidayService = HolidayService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final List<DateTime> _selectedDates = [];

  void _addHoliday() async {
    final title = _titleController.text.trim();
    final reason = _reasonController.text.trim();

    if (title.isEmpty || reason.isEmpty || _selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill title, reason, and pick dates')),
      );
      return;
    }

    try {

      final docRef = _holidayService.holidaysCollection.doc();

      final holiday = Holiday(
        id: docRef.id,
        title: title,
        dates: List.from(_selectedDates),
        reason: reason,
      );
      await _holidayService.addHolidayWithId(holiday);


      // Step 3: clear UI
      _titleController.clear();
      _reasonController.clear();
      setState(() => _selectedDates.clear());

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add holiday: $e')),
      );
    }
  }


  void _showAddHolidayDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Holiday'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Holiday Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason for Holiday'),
              ),
              const SizedBox(height: 12),
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
                label: const Text('Pick Date (can pick multiple)'),
              ),
              const SizedBox(height: 8),
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
            onPressed: _addHoliday,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Holiday>>(
        stream: _holidayService.getAllHolidays(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final holidays = snapshot.data ?? [];

          if (holidays.isEmpty) {
            return const Center(child: Text('No holidays added.'));
          }

          // Sort by first date descending (latest first)
          holidays.sort((a, b) => b.dates.first.compareTo(a.dates.first));


          return ListView.builder(
            itemCount: holidays.length,
            itemBuilder: (context, index) {
              final holiday = holidays[index];
              final dateStr = holiday.dates
                  .map((d) => DateFormat('dd MMM').format(d))
                  .join(', ');

              final today = DateTime.now();
              final lastDate = holiday.dates.reduce((a, b) => a.isAfter(b) ? a : b);
              final isPast = lastDate.isBefore(DateTime(today.year, today.month, today.day));

              return Stack(
                children: [
                  Opacity(
                    opacity: isPast ? 0.5 : 1.0, // ✅ semi-transparent if expired
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: ColorManager.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isPast ? Colors.grey.shade500 : ColorManager.burntOrange, // ✅ highlight upcoming
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HolidayDetailPage(
                                userType: widget.userType,
                                holidayId: holiday.id,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.calendar_month, color: ColorManager.burntOrange),
                        title: Text(
                          holiday.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason: ${holiday.reason}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dates: $dateStr',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        trailing: isPast
                            ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Expired',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                            : Icon(Icons.event_available, color: ColorManager.darkMint),
                      ),
                    ),
                  ),
                ],
              );
            },
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


