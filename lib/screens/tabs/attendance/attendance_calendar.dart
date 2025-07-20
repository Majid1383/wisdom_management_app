//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../models/attendance_model/monthly_attendance.dart';
// import '../../../models/new_student_model/new_student.dart';
// import '../../../services/attendance_service.dart';
// import '../../../theme/color_manager.dart';
// import '../../../utils/UserType.dart';
//
// class AttendanceCalendarScreen extends StatefulWidget {
//   final List<Student> students;
//   final UserType userType;
//
//   const AttendanceCalendarScreen({
//     super.key,
//     required this.students,
//     required this.userType,
//   });
//
//   @override
//   State<AttendanceCalendarScreen> createState() => _AttendanceCalendarScreenState();
// }
//
// class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
//   late Student selectedStudent;
//   late Future<Map<String, Attendance>> attendanceMapFuture;
//
//
//   @override
//   void initState() {
//     super.initState();
//     selectedStudent = widget.students.first; // default to first student
//     attendanceMapFuture = _fetchAttendanceMap(selectedStudent);
//   }
//
//   Future<Map<String, Attendance>> _fetchAttendanceMap(Student student) async {
//     final service = AttendanceService();
//     final list = await service.getAttendanceByDateRange(
//       student.uuid,
//       student.joined,
//       DateTime.now(),
//     );
//     return {
//       for (var att in list) DateFormat('yyyy-MM-dd').format(att.date): att
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final months = _generateMonths(selectedStudent.joined, now);
//
//     return Scaffold(
//       // appBar: AppBar(title: Text('Attendance')),
//       backgroundColor: ColorManager.lightCoolGrey,
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (widget.userType != UserType.admin)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                     decoration: BoxDecoration(
//                       color: ColorManager.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: ColorManager.tealAccent, width: 1.5),
//                     ),
//                     child: DropdownButton<Student>(
//                       value: selectedStudent,
//                       underline: const SizedBox(),
//                       icon: const Icon(Icons.arrow_drop_down, color: ColorManager.tealAccent),
//                       dropdownColor: ColorManager.white,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: ColorManager.darkCharcoal,
//                       ),
//                       onChanged: (newStudent) {
//                         if (newStudent != null) {
//                           setState(() {
//                             selectedStudent = newStudent;
//                             attendanceMapFuture = _fetchAttendanceMap(selectedStudent);
//                           });
//                         }
//                       },
//                       items: widget.students.map((student) {
//                         return DropdownMenuItem<Student>(
//                           value: student,
//                           child: Text(student.firstName),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: FutureBuilder<Map<String, Attendance>>(
//                 future: attendanceMapFuture,
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   final attendanceMap = snapshot.data!;
//
//                   return ListView(
//                     children: [
//                       ...months.map((monthData) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               DateFormat('MMMM yyyy').format(monthData.month),
//                               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                 color: ColorManager.tealAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             _buildMonthGrid(monthData.days, attendanceMap),
//                             const SizedBox(height: 24),
//                           ],
//                         );
//                       }),
//                       _buildLegendRow(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildMonthGrid(List<DateTime> days, Map<String, Attendance> attendanceMap) {
//   //   return GridView.builder(
//   //     shrinkWrap: true,
//   //     physics: const NeverScrollableScrollPhysics(),
//   //     itemCount: days.length,
//   //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //       crossAxisCount: 7,
//   //       crossAxisSpacing: 8,
//   //       mainAxisSpacing: 8,
//   //     ),
//   //     itemBuilder: (context, index) {
//   //       final date = days[index];
//   //       final dateStr = DateFormat('yyyy-MM-dd').format(date);
//   //       final attendance = attendanceMap[dateStr];
//   //
//   //       final isPresent = attendance?.status == 'present';
//   //       final isAbsent = attendance?.status == 'absent';
//   //       final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;
//   //       final isSunday = date.weekday == DateTime.sunday;
//   //
//   //       // Note dot color: green if present, red if absent
//   //       final noteDotColor = isPresent ? Colors.green : (isAbsent ? Colors.red : Colors.red);
//   //
//   //       Color backgroundColor;
//   //       Color borderColor;
//   //       Color textColor;
//   //
//   //       if (isPresent) {
//   //         backgroundColor = ColorManager.tealAccent.withOpacity(0.3);
//   //         borderColor = ColorManager.tealAccent;
//   //         textColor = ColorManager.tealAccent;
//   //       } else if (isAbsent) {
//   //         backgroundColor = Colors.redAccent.withOpacity(0.2);   // light red background
//   //         borderColor = Colors.redAccent;                        // red border
//   //         textColor = Colors.redAccent;                          // red text
//   //       } else if (isSunday) {
//   //         // Sunday styled like Present but with blue
//   //         backgroundColor = Colors.blueAccent.withOpacity(0.2);
//   //         borderColor = Colors.blueAccent.withOpacity(0.6);
//   //         textColor = Colors.blueAccent;
//   //       } else {
//   //         backgroundColor = Colors.transparent;
//   //         borderColor = ColorManager.darkCharcoal.withOpacity(0.7);
//   //         textColor = ColorManager.charcoalGray.withOpacity(0.9);
//   //       }
//   //
//   //       return GestureDetector(
//   //         onTap: () {
//   //           if (widget.userType == UserType.admin || widget.userType == UserType.teacher) {
//   //             _showAttendanceBottomSheet(
//   //               context,
//   //               date,
//   //               currentStatus: attendance?.status,
//   //               currentNote: attendance?.note,
//   //             );
//   //           }
//   //         },
//   //         child: Container(
//   //           decoration: BoxDecoration(
//   //             color: backgroundColor,
//   //             border: Border.all(color: borderColor, width: 1.5),
//   //             borderRadius: BorderRadius.circular(8),
//   //           ),
//   //           alignment: Alignment.center,
//   //           child: Stack(
//   //             children: [
//   //               Center(
//   //                 child: Text(
//   //                   '${date.day}',
//   //                   style: TextStyle(
//   //                     color: textColor,
//   //                     fontWeight: FontWeight.bold,
//   //                   ),
//   //                 ),
//   //               ),
//   //               if (hasNote)
//   //                 Positioned(
//   //                   top: 2,
//   //                   right: 2,
//   //                   child: Container(
//   //                     width: 8,
//   //                     height: 8,
//   //                     decoration: BoxDecoration(
//   //                       color: noteDotColor,
//   //                       shape: BoxShape.circle,
//   //                     ),
//   //                   ),
//   //                 ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//   Widget _buildMonthGrid(List<DateTime> days, Map<String, Attendance> attendanceMap) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: days.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 7,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemBuilder: (context, index) {
//         final date = days[index];
//         final dateStr = DateFormat('yyyy-MM-dd').format(date);
//         final attendance = attendanceMap[dateStr];
//
//         final isPresent = attendance?.status == 'present';
//         final isAbsent = attendance?.status == 'absent';
//         final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;
//         final isSunday = date.weekday == DateTime.sunday;
//
//         final noteDotColor = isPresent ? Colors.green : (isAbsent ? Colors.red : Colors.red);
//
//         Color backgroundColor;
//         Color borderColor;
//         Color textColor;
//
//         if (isPresent) {
//           backgroundColor = ColorManager.tealAccent.withOpacity(0.3);
//           borderColor = ColorManager.tealAccent;
//           textColor = ColorManager.tealAccent;
//         } else if (isAbsent) {
//           backgroundColor = Colors.redAccent.withOpacity(0.2);
//           borderColor = Colors.redAccent;
//           textColor = Colors.redAccent;
//         } else if (isSunday) {
//           backgroundColor = Colors.blueAccent.withOpacity(0.2);
//           borderColor = Colors.blueAccent.withOpacity(0.6);
//           textColor = Colors.blueAccent;
//         } else {
//           backgroundColor = Colors.transparent;
//           borderColor = ColorManager.darkCharcoal.withOpacity(0.7);
//           textColor = ColorManager.charcoalGray.withOpacity(0.9);
//         }
//
//         return GestureDetector(
//           onTap: () {
//             if (widget.userType == UserType.admin || widget.userType == UserType.teacher) {
//               if (date.isAfter(DateTime.now())) {
//                 // 🔥 Show snackbar if the tapped date is in the future
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('You need to mark attendance on the current day itself.'),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );
//               } else {
//                 // Open bottom sheet for today or past dates
//                 _showAttendanceBottomSheet(
//                   context,
//                   date,
//                   currentStatus: attendance?.status,
//                   currentNote: attendance?.note,
//                 );
//               }
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               border: Border.all(color: borderColor, width: 1.5),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             alignment: Alignment.center,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Text(
//                     '${date.day}',
//                     style: TextStyle(
//                       color: textColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 if (hasNote)
//                   Positioned(
//                     top: 2,
//                     right: 2,
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: noteDotColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
//   void _showAttendanceBottomSheet(
//       BuildContext context,
//       DateTime date, {
//         String? currentStatus,
//         String? currentNote,
//       }) {
//     bool isPresent = currentStatus == 'present';
//     final noteController = TextEditingController(text: currentNote ?? '');
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.6,
//           minChildSize: 0.4,
//           maxChildSize: 0.95,
//           builder: (context, scrollController) {
//             return StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SingleChildScrollView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(16).copyWith(
//                     bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade400,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         DateFormat('dd MMMM yyyy').format(date),
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: ColorManager.tealAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             isPresent ? 'Present' : 'Absent',
//                             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                               color: isPresent ? ColorManager.tealAccent : Colors.pink,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24
//                             ),
//                           ),
//                           Switch(
//                             value: isPresent,
//                             activeColor: ColorManager.tealAccent,
//                             onChanged: (value) {
//                               setModalState(() {
//                                 isPresent = value;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       TextField(
//                         controller: noteController,
//                         decoration: const InputDecoration(
//                           labelText: 'Note / Homework',
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorManager.tealAccent,
//                           ),
//                           onPressed: () async {
//                             Navigator.pop(context);
//                             await _saveAttendance(
//                               date,
//                               isPresent ? 'present' : 'absent',
//                               noteController.text,
//                             );
//                             setState(() {
//                               attendanceMapFuture = _fetchAttendanceMap(selectedStudent);
//                             });
//                           },
//                           child: const Text('Save', style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _saveAttendance(DateTime date, String status, String note) async {
//     final service = AttendanceService();
//     final dateStr = DateFormat('yyyy-MM-dd').format(date);
//     final attendanceId = '${selectedStudent.uuid}_$dateStr';
//
//     final att = Attendance(
//       id: attendanceId,
//       studentId: selectedStudent.uuid,
//       status: status,
//       date: date,
//       note: note.isEmpty ? null : note,
//     );
//
//     try {
//       await service.addAttendance(att);
//     } catch (e) {
//       print('Error saving attendance: $e');
//     }
//   }
//
//   List<MonthData> _generateMonths(DateTime start, DateTime end) {
//     List<MonthData> months = [];
//     DateTime current = DateTime(start.year, start.month);
//     while (!current.isAfter(DateTime(end.year, end.month))) {
//       final firstDay = (current.year == start.year && current.month == start.month)
//           ? start
//           : DateTime(current.year, current.month, 1);
//       final lastDay = (current.year == end.year && current.month == end.month)
//           ? end
//           : DateTime(current.year, current.month + 1, 0);
//       List<DateTime> days = [];
//       for (DateTime d = firstDay; !d.isAfter(lastDay); d = d.add(const Duration(days: 1))) {
//         days.add(d);
//       }
//       months.add(MonthData(month: current, days: days));
//       current = DateTime(current.year, current.month + 1);
//     }
//     return months.reversed.toList();
//   }
//
//   // static Widget _buildLegendRow() {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       _legendBox(ColorManager.tealAccent, 'Present'),
//   //       const SizedBox(width: 16),
//   //       _legendBox(Colors.transparent, 'Absent', outlined: true),
//   //     ],
//   //   );
//   // }
//   //
//   // static Widget _legendBox(Color color, String label, {bool outlined = false}) {
//   //   return Row(
//   //     children: [
//   //       Container(
//   //         width: 16,
//   //         height: 16,
//   //         decoration: BoxDecoration(
//   //           color: outlined ? Colors.transparent : color,
//   //           border: Border.all(
//   //             color: outlined ? ColorManager.lightGrey : color,
//   //             width: 1.5,
//   //           ),
//   //           borderRadius: BorderRadius.circular(4),
//   //         ),
//   //       ),
//   //       const SizedBox(width: 4),
//   //       Text(label),
//   //     ],
//   //   );
//   // }
//
//   static Widget _buildLegendRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _legendBox(ColorManager.tealAccent, 'Present'),
//         const SizedBox(width: 16),
//         _legendBox(Colors.redAccent, 'Absent'),
//         const SizedBox(width: 16),
//         _legendBox(Colors.blueAccent, 'Sunday'),
//       ],
//     );
//   }
//
//   static Widget _legendBox(Color color, String label, {bool outlined = false}) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: outlined ? Colors.transparent : color,
//             border: Border.all(
//               color: color,
//               width: 1.5,
//             ),
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(label),
//       ],
//     );
//   }
// }
//
// class MonthData {
//   final DateTime month;
//   final List<DateTime> days;
//   MonthData({required this.month, required this.days});
// }
//
//
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/attendance_model/monthly_attendance.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../services/attendance_service.dart';
import '../../../theme/color_manager.dart';
import '../../../utils/UserType.dart';

class AttendanceCalendarScreen extends StatefulWidget {
  final List<Student> students;
  final UserType userType;

  const AttendanceCalendarScreen({
    super.key,
    required this.students,
    required this.userType,
  });

  @override
  State<AttendanceCalendarScreen> createState() => _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
  late Student selectedStudent;
  late Future<Map<String, Attendance>> attendanceMapFuture;

  @override
  void initState() {
    super.initState();
    selectedStudent = widget.students.first; // default to first student
    attendanceMapFuture = _fetchAttendanceMap(selectedStudent);
  }

  Future<Map<String, Attendance>> _fetchAttendanceMap(Student student) async {
    final service = AttendanceService();
    final list = await service.getAttendanceByDateRange(
      student.uuid,
      student.joined,
      DateTime.now(),
    );
    return {for (var att in list) DateFormat('yyyy-MM-dd').format(att.date): att};
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = _generateMonths(selectedStudent.joined, now).reversed.toList();

    return Scaffold(
      backgroundColor: ColorManager.lightCoolGrey,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.userType != UserType.admin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorManager.tealAccent, width: 1.5),
                    ),
                    child: DropdownButton<Student>(
                      value: selectedStudent,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: ColorManager.tealAccent),
                      dropdownColor: ColorManager.white,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.darkCharcoal,
                      ),
                      onChanged: (newStudent) {
                        if (newStudent != null) {
                          setState(() {
                            selectedStudent = newStudent;
                            attendanceMapFuture = _fetchAttendanceMap(selectedStudent);
                          });
                        }
                      },
                      items: widget.students.map((student) {
                        return DropdownMenuItem<Student>(
                          value: student,
                          child: Text(student.firstName),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, Attendance>>(
                future: attendanceMapFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final attendanceMap = snapshot.data!;

                  return ListView(
                    children: [
                      ...months.map((monthData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(monthData.month),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: ColorManager.tealAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildMonthGrid(monthData.days, attendanceMap),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                      _buildLegendRow(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthGrid(List<DateTime> days, Map<String, Attendance> attendanceMap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final date = days[index];
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        final attendance = attendanceMap[dateStr];

        final isPresent = attendance?.status == 'present';
        final isAbsent = attendance?.status == 'absent';
        final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;
        final isSunday = date.weekday == DateTime.sunday;

        final noteDotColor = isPresent ? Colors.green : (isAbsent ? Colors.red : Colors.red);

        Color backgroundColor;
        Color borderColor;
        Color textColor;

        if (isPresent) {
          backgroundColor = ColorManager.tealAccent.withOpacity(0.3);
          borderColor = ColorManager.tealAccent;
          textColor = ColorManager.tealAccent;
        } else if (isAbsent) {
          backgroundColor = Colors.redAccent.withOpacity(0.2);
          borderColor = Colors.redAccent;
          textColor = Colors.redAccent;
        } else if (isSunday) {
          backgroundColor = Colors.blueAccent.withOpacity(0.2);
          borderColor = Colors.blueAccent.withOpacity(0.6);
          textColor = Colors.blueAccent;
        } else {
          backgroundColor = Colors.transparent;
          borderColor = ColorManager.darkCharcoal.withOpacity(0.7);
          textColor = ColorManager.charcoalGray.withOpacity(0.9);
        }

        return GestureDetector(
          onTap: () {
            final isToday = DateFormat('yyyy-MM-dd').format(date) ==
                DateFormat('yyyy-MM-dd').format(DateTime.now());

            if (widget.userType == UserType.admin || widget.userType == UserType.teacher) {
              if (isToday) {
                _showAttendanceBottomSheet(
                  context,
                  date,
                  currentStatus: attendance?.status,
                  currentNote: attendance?.note,
                );
              } else {
                _showCustomSnackBar('You need to mark attendance on the current day itself.');
              }
            } else if (widget.userType == UserType.parent) {
              // Parent view:
              if (attendance != null) {
                _showAttendanceDetailsDialog(date, attendance);
              } else {
                _showCustomSnackBar('No attendance record for this date.');
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (hasNote)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: noteDotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAttendanceDetailsDialog(DateTime date, Attendance attendance) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            DateFormat('dd MMMM yyyy').format(date),
            style: const TextStyle(
              color: ColorManager.tealAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorManager.charcoalGray, // darker color for label
                    ),
                  ),
                  Text(
                    attendance.status == 'present' ? 'Present' : 'Absent',
                    style: TextStyle(
                      color: attendance.status == 'present'
                          ? ColorManager.tealAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (attendance.note != null && attendance.note!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note / Homework:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorManager.darkCharcoal, // darker color for label
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      attendance.note!,
                      style: const TextStyle(color: ColorManager.darkCharcoal),
                    ),
                  ],
                )
              else
                const Text(
                  'No note added.',
                  style: TextStyle(color: ColorManager.darkCharcoal),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: ColorManager.tealAccent)),
            ),
          ],
        );
      },
    );
  }



  void _showAttendanceBottomSheet(
      BuildContext context,
      DateTime date, {
        String? currentStatus,
        String? currentNote,
      }) {
    bool isPresent = currentStatus == 'present';
    final noteController = TextEditingController(text: currentNote ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16).copyWith(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        DateFormat('dd MMMM yyyy').format(date),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorManager.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isPresent ? 'Present' : 'Absent',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isPresent ? ColorManager.tealAccent : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Switch(
                            value: isPresent,
                            activeColor: ColorManager.tealAccent,
                            onChanged: (value) {
                              setModalState(() {
                                isPresent = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          labelText: 'Note / Homework',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.tealAccent,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await _saveAttendance(
                              date,
                              isPresent ? 'present' : 'absent',
                              noteController.text,
                            );
                            setState(() {
                              attendanceMapFuture = _fetchAttendanceMap(selectedStudent);
                            });
                          },
                          child: const Text('Save', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showCustomSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);

    // Close current snackbar if showing
    messenger.hideCurrentSnackBar();

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorManager.tealAccent,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const Icon(Icons.info, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      duration: const Duration(seconds: 2),
    );

    messenger.showSnackBar(snackBar);
  }


  Future<void> _saveAttendance(DateTime date, String status, String note) async {
    final service = AttendanceService();
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final attendanceId = '${selectedStudent.uuid}_$dateStr';

    final att = Attendance(
      id: attendanceId,
      studentId: selectedStudent.uuid,
      status: status,
      date: date,
      note: note.isEmpty ? null : note,
    );

    try {
      await service.addAttendance(att);
    } catch (e) {
      print('Error saving attendance: $e');
    }
  }

  List<MonthData> _generateMonths(DateTime start, DateTime end) {
    List<MonthData> months = [];
    DateTime current = DateTime(start.year, start.month);
    while (!current.isAfter(DateTime(end.year, end.month))) {
      final firstDay = (current.year == start.year && current.month == start.month)
          ? start
          : DateTime(current.year, current.month, 1);
      final lastDay = (current.year == end.year && current.month == end.month)
          ? end
          : DateTime(current.year, current.month + 1, 0);
      List<DateTime> days = [];
      for (DateTime d = firstDay; !d.isAfter(lastDay); d = d.add(const Duration(days: 1))) {
        days.add(d);
      }
      months.add(MonthData(month: current, days: days));
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  static Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendBox(ColorManager.tealAccent, 'Present'),
        const SizedBox(width: 16),
        _legendBox(Colors.redAccent, 'Absent'),
        const SizedBox(width: 16),
        _legendBox(Colors.blueAccent, 'Sunday'),
      ],
    );
  }

  static Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class MonthData {
  final DateTime month;
  final List<DateTime> days;
  MonthData({required this.month, required this.days});
}

