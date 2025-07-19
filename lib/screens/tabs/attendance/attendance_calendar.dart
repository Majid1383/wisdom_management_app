// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../constants/user_type.dart';
// import '../../../models/attendance_model/monthly_attendance.dart';
// import '../../../models/new_student_model/new_student.dart';
// import '../../../services/attendance_service.dart';
// import '../../../theme/color_manager.dart';
//
// class AttendanceCalendarScreen extends StatefulWidget {
//   final Student student;
//   final UserType userType;
//
//   const AttendanceCalendarScreen({
//     super.key,
//     required this.student,
//     required DateTime joiningDate,
//     required this.userType,
//   });
//
//   @override
//   State<AttendanceCalendarScreen> createState() => _AttendanceCalendarScreenState();
// }
//
// class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
//   late Future<Map<String, Attendance>> attendanceMapFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     attendanceMapFuture = _fetchAttendanceMap();
//   }
//
//   Future<Map<String, Attendance>> _fetchAttendanceMap() async {
//     final service = AttendanceService();
//     final list = await service.getAttendanceByDateRange(
//       widget.student.uuid,
//       widget.student.joined,
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
//     final months = _generateMonths(widget.student.joined, now);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('${widget.student.firstName} Attendance')),
//       backgroundColor: ColorManager.lightCoolGrey,
//       body: FutureBuilder<Map<String, Attendance>>(
//         future: attendanceMapFuture,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final attendanceMap = snapshot.data!;
//
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: ListView(
//               children: [
//                 ...months.map((monthData) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         DateFormat('MMMM yyyy').format(monthData.month),
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: ColorManager.tealAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildMonthGrid(monthData.days, attendanceMap),
//                       const SizedBox(height: 24),
//                     ],
//                   );
//                 }),
//                 _buildLegendRow(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
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
//         final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;
//
//         return GestureDetector(
//           onTap: () {
//             if (widget.userType == UserType.admin) {
//               _showAttendanceBottomSheet(
//                 context,
//                 date,
//                 currentStatus: attendance?.status,
//                 currentNote: attendance?.note,
//               );
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: isPresent ? ColorManager.tealAccent.withOpacity(0.3) : Colors.transparent,
//               border: Border.all(
//                 color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal.withOpacity(0.7),
//                 width: 1.5,
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             alignment: Alignment.center,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Text(
//                     '${date.day}',
//                     style: TextStyle(
//                       color: isPresent
//                           ? ColorManager.tealAccent
//                           : ColorManager.charcoalGray.withOpacity(0.9),
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
//                         color: Colors.green,
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
//                               color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal,
//                               fontWeight: FontWeight.bold,
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
//                             // Reload data
//                             setState(() {
//                               attendanceMapFuture = _fetchAttendanceMap();
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
//     final attendanceId = '${widget.student.uuid}_$dateStr';
//
//     final att = Attendance(
//       id: attendanceId,
//       studentId: widget.student.uuid,
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
//     return months;
//   }
//
//   static Widget _buildLegendRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _legendBox(ColorManager.mintGreen, 'Present'),
//         const SizedBox(width: 16),
//         _legendBox(Colors.transparent, 'Absent', outlined: true),
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
//               color: outlined ? ColorManager.lightGrey : color,
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


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../models/attendance_model/monthly_attendance.dart';
// import '../../../models/new_student_model/new_student.dart';
// import '../../../services/attendance_service.dart';
// import '../../../theme/color_manager.dart';
// import '../../../utils/UserType.dart';
//
// // enum UserType { parent, teacher, admin }
//
// class AttendanceCalendarScreen extends StatefulWidget {
//   final Student student;
//
//   const AttendanceCalendarScreen({
//     super.key,
//     required this.student, required DateTime joiningDate, required UserType userType,
//   });
//
//   @override
//   State<AttendanceCalendarScreen> createState() => _AttendanceCalendarScreenState();
// }
//
// class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
//   late Future<Map<String, Attendance>> attendanceMapFuture;
//   UserType? userType;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserType();
//     attendanceMapFuture = _fetchAttendanceMap();
//   }
//
//   Future<void> _loadUserType() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userTypeString = prefs.getString('userType');
//
//     setState(() {
//       switch (userTypeString) {
//         case 'admin':
//           userType = UserType.admin;
//           break;
//         case 'teacher':
//           userType = UserType.teacher;
//           break;
//         default:
//           userType = UserType.parent;
//       }
//     });
//   }
//
//   Future<Map<String, Attendance>> _fetchAttendanceMap() async {
//     final service = AttendanceService();
//     final list = await service.getAttendanceByDateRange(
//       widget.student.uuid,
//       widget.student.joined,
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
//     final months = _generateMonths(widget.student.joined, now);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('${widget.student.firstName} Attendance')),
//       backgroundColor: ColorManager.lightCoolGrey,
//       body: FutureBuilder<Map<String, Attendance>>(
//         future: attendanceMapFuture,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData || userType == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final attendanceMap = snapshot.data!;
//
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: ListView(
//               children: [
//                 ...months.map((monthData) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         DateFormat('MMMM yyyy').format(monthData.month),
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: ColorManager.tealAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildMonthGrid(monthData.days, attendanceMap),
//                       const SizedBox(height: 24),
//                     ],
//                   );
//                 }),
//                 _buildLegendRow(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
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
//         final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;
//
//         return GestureDetector(
//           onTap: () {
//             if (userType == UserType.admin) {
//               _showAttendanceBottomSheet(
//                 context,
//                 date,
//                 currentStatus: attendance?.status,
//                 currentNote: attendance?.note,
//               );
//             } else if (userType == UserType.teacher) {
//               _showAttendanceBottomSheet(
//                 context,
//                 date,
//                 currentStatus: attendance?.status,
//                 currentNote: attendance?.note,
//               );
//             } else {
//               // Parent: do nothing or show read-only
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: isPresent ? ColorManager.tealAccent.withOpacity(0.3) : Colors.transparent,
//               border: Border.all(
//                 color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal.withOpacity(0.7),
//                 width: 1.5,
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             alignment: Alignment.center,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Text(
//                     '${date.day}',
//                     style: TextStyle(
//                       color: isPresent
//                           ? ColorManager.tealAccent
//                           : ColorManager.charcoalGray.withOpacity(0.9),
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
//                       decoration: const BoxDecoration(
//                         color: Colors.green,
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
//                               color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal,
//                               fontWeight: FontWeight.bold,
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
//                             // Reload data
//                             setState(() {
//                               attendanceMapFuture = _fetchAttendanceMap();
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
//     final attendanceId = '${widget.student.uuid}_$dateStr';
//
//     final att = Attendance(
//       id: attendanceId,
//       studentId: widget.student.uuid,
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
//     return months;
//   }
//
//   static Widget _buildLegendRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _legendBox(ColorManager.tealAccent, 'Present'),
//         const SizedBox(width: 16),
//         _legendBox(Colors.transparent, 'Absent', outlined: true),
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
//               color: outlined ? ColorManager.lightGrey : color,
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
//       // appBar: AppBar(title: const Text('Attendance')),
//       backgroundColor: ColorManager.lightCoolGrey,
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Dropdown to select child
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
//                       underline: const SizedBox(), // remove default underline
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
//             // Calendar
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
//         final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;
//
//         return Container(
//           decoration: BoxDecoration(
//             color: isPresent ? ColorManager.tealAccent.withOpacity(0.3) : Colors.transparent,
//             border: Border.all(
//               color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal.withOpacity(0.7),
//               width: 1.5,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           alignment: Alignment.center,
//           child: Stack(
//             children: [
//               Center(
//                 child: Text(
//                   '${date.day}',
//                   style: TextStyle(
//                     color: isPresent
//                         ? ColorManager.tealAccent
//                         : ColorManager.charcoalGray.withOpacity(0.9),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               if (hasNote)
//                 Positioned(
//                   top: 2,
//                   right: 2,
//                   child: Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
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
//     return months;
//   }
//
//   static Widget _buildLegendRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _legendBox(ColorManager.tealAccent, 'Present'),
//         const SizedBox(width: 16),
//         _legendBox(Colors.transparent, 'Absent', outlined: true),
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
//               color: outlined ? ColorManager.lightGrey : color,
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
    return {
      for (var att in list) DateFormat('yyyy-MM-dd').format(att.date): att
    };
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = _generateMonths(selectedStudent.joined, now);

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
        final hasNote = attendance?.note != null && attendance!.note!.isNotEmpty;

        return GestureDetector(
          onTap: () {
            if (widget.userType == UserType.admin || widget.userType == UserType.teacher) {
              _showAttendanceBottomSheet(
                context,
                date,
                currentStatus: attendance?.status,
                currentNote: attendance?.note,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isPresent ? ColorManager.tealAccent.withOpacity(0.3) : Colors.transparent,
              border: Border.all(
                color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal.withOpacity(0.7),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isPresent
                          ? ColorManager.tealAccent
                          : ColorManager.charcoalGray.withOpacity(0.9),
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
                      decoration: const BoxDecoration(
                        color: Colors.green,
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
                              color: isPresent ? ColorManager.tealAccent : ColorManager.darkCharcoal,
                              fontWeight: FontWeight.bold,
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
        _legendBox(Colors.transparent, 'Absent', outlined: true),
      ],
    );
  }

  static Widget _legendBox(Color color, String label, {bool outlined = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : color,
            border: Border.all(
              color: outlined ? ColorManager.lightGrey : color,
              width: 1.5,
            ),
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



