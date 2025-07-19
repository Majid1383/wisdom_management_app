// import 'package:flutter/material.dart';
// import 'package:wisdom_management_app/constants/user_type.dart';
// import 'package:wisdom_management_app/screens/tabs/all_students/all_student_screen.dart';
// import 'package:wisdom_management_app/screens/tabs/profile/profile_screen.dart';
// import '../../../models/attendance_model/monthly_attendance.dart';
// import '../../../models/new_student_model/new_student.dart';
// import '../../../services/auth_service.dart';
// import '../../../services/firestore_service.dart';
// import '../../../theme/color_manager.dart';
// import '../../../widgets /global_drawer/global_drawer.dart';
// import '../attendance/attendance_screen.dart';
// import '../holiday/holiday_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final UserType userType;
//
//   const HomeScreen({super.key, required this.userType});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   final FirestoreService _firestoreService = FirestoreService();
//   final AuthService _authService = AuthService();
//
//   late Future<List<Student>> _studentsFuture;
//
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.userType == UserType.student) {
//       _studentsFuture = _loadStudentData();
//
//     }
//   }
//
//   Future<List<Student>> _loadStudentData() async {
//     final currentUser = _authService.currentUser;
//     final parentEmail = currentUser?.email;
//     if (parentEmail != null) {
//       return await _firestoreService.getStudentsByParentEmail(parentEmail);
//     }
//     return [];
//   }
//
//
//
//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }
//
//   List<BottomNavigationBarItem> get _bottomNavItems {
//     if (widget.userType == UserType.admin) {
//       return const [
//         BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'In/Out'),
//         BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
//         BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fees'),
//         BottomNavigationBarItem(icon: Icon(Icons.people), label: 'All'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//       ];
//     } else {
//       return const [
//         BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
//         BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Attendance'),
//         BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//       ];
//     }
//   }
//
//   Widget _buildScaffold(List<Widget> pages) {
//     return Scaffold(
//       drawer: widget.userType == UserType.admin ?  GlobalDrawer() : null,
//       backgroundColor: ColorManager.lightCoolGrey,
//       appBar: AppBar(
//         title: const Text('Wisdom Tutorials'),
//       ),
//       body: pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: ColorManager.burntOrange,
//         unselectedItemColor: ColorManager.goldenSand,
//         backgroundColor: ColorManager.lightCoolGrey,
//         type: BottomNavigationBarType.fixed,
//         showSelectedLabels: true,
//         showUnselectedLabels: false,
//         items: _bottomNavItems,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.userType == UserType.admin) {
//       final adminPages = [
//         const _DashboardTab(),
//         const AttendanceScreen(),
//         HolidaysScreen(userType: widget.userType),
//         const Center(child: Text('Fees Placeholder')),
//         const AllStudentsScreen(),
//         // Dummy Profile for admin (optional)
//         const Center(child: Text('Admin Profile')),
//       ];
//       return _buildScaffold(adminPages);
//     }
//
//     // Parent/student view → load student data first
//     // return FutureBuilder<Student?>(
//     //   future: _studentFuture,
//     //   builder: (context, snapshot) {
//     //     if (snapshot.connectionState == ConnectionState.waiting) {
//     //       return const Scaffold(
//     //         body: Center(child: CircularProgressIndicator()),
//     //       );
//     //     }
//     //     if (snapshot.hasError) {
//     //       return Scaffold(
//     //         body: Center(child: Text('Error: ${snapshot.error}')),
//     //       );
//     //     }
//     //     final student = snapshot.data;
//     //     if (student == null) {
//     //       return const Scaffold(
//     //         body: Center(child: Text('No student data found')),
//     //       );
//     //     }
//     //
//     //     return FutureBuilder<List<Student>>(
//     //       future: _studentsFuture,
//     //       builder: (context, snapshot) {
//     //         if (snapshot.connectionState == ConnectionState.waiting) {
//     //           return const Scaffold(
//     //             body: Center(child: CircularProgressIndicator()),
//     //           );
//     //         }
//     //         if (snapshot.hasError) {
//     //           return Scaffold(
//     //             body: Center(child: Text('Error: ${snapshot.error}')),
//     //           );
//     //         }
//     //         final students = snapshot.data ?? [];
//     //         if (students.isEmpty) {
//     //           return const Scaffold(
//     //             body: Center(child: Text('No student data found')),
//     //           );
//     //         }
//     //
//     //         // For now: just use first student
//     //         final student = students.first;
//     //
//     //         final studentPages = [
//     //           const _DashboardTab(),
//     //           const AttendanceScreen(),
//     //           HolidaysScreen(userType: widget.userType),
//     //           ProfileScreen(student: student),
//     //         ];
//     //         return _buildScaffold(studentPages);
//     //       },
//     //     );
//     //
//     //
//     //     final studentPages = [
//     //       const _DashboardTab(),
//     //       const AttendanceScreen(),
//     //       HolidaysScreen(userType: widget.userType),
//     //       ProfileScreen(student: student),
//     //     ];
//     //     return _buildScaffold(studentPages);
//     //   },
//     // );
//
//     return FutureBuilder<List<Student>>(
//       future: _studentsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(child: Text('Error: ${snapshot.error}')),
//           );
//         }
//         final students = snapshot.data ?? [];
//         if (students.isEmpty) {
//           return const Scaffold(
//             body: Center(child: Text('No student data found')),
//           );
//         }
//
//         // For now: use the first student in the list
//         final student = students.first;
//
//
//
//         final studentPages = [
//           const _DashboardTab(),
//           const AttendanceScreen(),
//           HolidaysScreen(userType: widget.userType),
//           ProfileScreen(student: student,
//
//         ];
//
//         return _buildScaffold(studentPages);
//       },
//     );
//   }
// }
//
// class _DashboardTab extends StatelessWidget {
//   const _DashboardTab();
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime now = DateTime.now();
//     final String currentMonthName = _monthName(now.month);
//     final int currentYear = now.year;
//
//     final List<MonthlyAttendance> dummyAttendanceData = [
//       MonthlyAttendance(
//         month: 'July',
//         year: 2025,
//         presentDays: [1, 3, 5, 7, 9, 11, 13, 15, 17, 20],
//       ),
//     ];
//
//     final MonthlyAttendance? currentAttendance = dummyAttendanceData.firstWhere(
//           (record) => record.month == currentMonthName && record.year == currentYear,
//       orElse: () => MonthlyAttendance(month: currentMonthName, year: currentYear, presentDays: []),
//     );
//
//     final int totalDays = DateUtils.getDaysInMonth(now.year, now.month);
//     final int presentCount = currentAttendance!.presentDays.length;
//
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: Column(
//         children: [
//           const SizedBox(height: 12),
//           Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             color: ColorManager.white,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: ColorManager.darkMint, size: 36),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '$currentMonthName $currentYear Attendance',
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '$presentCount / $totalDays days present',
//                         style: TextStyle(
//                           color: ColorManager.burntOrange,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Icon(Icons.arrow_forward_ios_rounded,
//                       size: 16, color: ColorManager.goldenSand),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static String _monthName(int month) {
//     const names = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return names[month - 1];
//   }
// }



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:wisdom_management_app/models/attendance_model/monthly_attendance.dart';
// import 'package:wisdom_management_app/models/new_student_model/new_student.dart';
// import 'package:wisdom_management_app/screens/tabs/all_students/all_student_screen.dart';
// import 'package:wisdom_management_app/screens/tabs/attendance/attendance_screen.dart';
//
// import 'package:wisdom_management_app/screens/tabs/fees/student_fees_list_screen.dart';
// import 'package:wisdom_management_app/screens/tabs/fees/student_pending_payment_screen.dart';
// import 'package:wisdom_management_app/screens/tabs/holiday/holiday_screen.dart';
// import 'package:wisdom_management_app/screens/tabs/profile/profile_screen.dart';
// import 'package:wisdom_management_app/services/auth_service.dart';
// import 'package:wisdom_management_app/services/firestore_service.dart';
// import 'package:wisdom_management_app/theme/color_manager.dart';
// import 'package:wisdom_management_app/widgets /global_drawer/global_drawer.dart';
//
// import '../attendance/attendance_calendar.dart';
// import '../attendance/student_attendance_list/attendance_list_screen.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   final UserType userType;
//   const HomeScreen({super.key, required this.userType});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final FirestoreService _firestoreService = FirestoreService();
//   final AuthService _authService = AuthService();
//
//   late Future<List<Student>> _studentsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.userType == UserType.parent) {
//       _studentsFuture = _loadStudentData();
//     }
//   }
//
//   Future<List<Student>> _loadStudentData() async {
//     final currentUser = _authService.currentUser;
//     final parentEmail = currentUser?.email;
//     if (parentEmail != null) {
//       return await _firestoreService.getStudentsByParentEmail(parentEmail);
//     }
//     return [];
//   }
//
//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }
//
//   List<BottomNavigationBarItem> get _bottomNavItems {
//     if (widget.userType == UserType.admin) {
//       return const [
//         BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'In/Out'),
//         BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
//         BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fees'),
//         BottomNavigationBarItem(icon: Icon(Icons.people), label: 'All'),
//         // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//       ];
//     } else {
//       return const [
//         BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'In/Out'),
//         BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
//         BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fees'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//
//
//       ];
//     }
//   }
//
//   Widget _buildScaffold(List<Widget> pages) {
//     return Scaffold(
//       drawer: widget.userType == UserType.admin ? GlobalDrawer() : null,
//       backgroundColor: ColorManager.lightCoolGrey,
//       appBar: AppBar(title: const Text('Wisdom Tutorials')),
//       body: pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: ColorManager.tealAccent,
//         unselectedItemColor: ColorManager.charcoalGray,
//         backgroundColor: ColorManager.lightCoolGrey,
//         type: BottomNavigationBarType.fixed,
//         showSelectedLabels: true,
//         showUnselectedLabels: false,
//         items: _bottomNavItems,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.userType == UserType.admin) {
//       final adminPages = [
//         const _DashboardTab(),
//         const AttendanceListScreen(),
//         HolidaysScreen(userType: UserType.parent),
//         StudentsFeesListScreen(),
//         const AllStudentsScreen(),
//         const Center(child: Text('Admin Profile')),
//       ];
//       return _buildScaffold(adminPages);
//     }
//
//     // Parent/student user → load students first
//     return FutureBuilder<List<Student>>(
//       future: _studentsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//         if (snapshot.hasError) {
//           return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
//         }
//
//         final students = snapshot.data ?? [];
//         if (students.isEmpty) {
//           return const Scaffold(body: Center(child: Text('No student data found')));
//         }
//
//         final studentPages = [
//           const _DashboardTab(),
//           // AttendanceScreen(student: students.first), // show attendance for this student directly
//           AttendanceCalendarScreen(student: students.first, joiningDate: students.first.joined, userType: widget.userType),
//           HolidaysScreen(userType: widget.userType),
//           StudentPaymentScreen(student: students.first, userType: widget.userType),
//           ProfileScreen(students: students),
//         ];
//         return _buildScaffold(studentPages);
//       },
//     );
//   }
// }
//
// class _DashboardTab extends StatelessWidget {
//   const _DashboardTab();
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime now = DateTime.now();
//     final String currentMonthName = _monthName(now.month);
//     final int currentYear = now.year;
//
//
//     final int totalDays = DateUtils.getDaysInMonth(now.year, now.month);
//
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: Column(
//         children: [
//           const SizedBox(height: 12),
//           Card(
//             elevation: 6,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             color: ColorManager.white,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: ColorManager.darkCharcoal, size: 36),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '$currentMonthName $currentYear Attendance',
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       const SizedBox(height: 4),
//
//                     ],
//                   ),
//                   const Spacer(),
//                   Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ColorManager.charcoalGray),
//
//                   const SizedBox(height: 12),
//
//
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height : 12),
//
//
//         ],
//       ),
//     );
//   }
//
//   static String _monthName(int month) {
//     const names = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return names[month - 1];
//   }
// }







import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisdom_management_app/models/new_student_model/new_student.dart';
import 'package:wisdom_management_app/screens/tabs/all_students/all_student_screen.dart';
import 'package:wisdom_management_app/screens/tabs/attendance/attendance_calendar.dart';
import 'package:wisdom_management_app/screens/tabs/attendance/student_attendance_list/attendance_list_screen.dart';
import 'package:wisdom_management_app/screens/tabs/fees/student_fees_list_screen.dart';
import 'package:wisdom_management_app/screens/tabs/fees/student_pending_payment_screen.dart';
import 'package:wisdom_management_app/screens/tabs/holiday/holiday_screen.dart';
import 'package:wisdom_management_app/screens/tabs/profile/profile_screen.dart';
import 'package:wisdom_management_app/services/auth_service.dart';
import 'package:wisdom_management_app/services/firestore_service.dart';
import 'package:wisdom_management_app/theme/color_manager.dart';

import 'package:wisdom_management_app/widgets /global_drawer/global_drawer.dart';

import '../../../extensions/user_type_extension.dart';
import '../../../utils/UserType.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required UserType userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  UserType? _userType; // loaded dynamically
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');

    final userType = UserTypeExtension.fromString(userTypeString);

    setState(() {
      _userType = userType ?? UserType.parent;
      if (_userType == UserType.parent) {
        _studentsFuture = _loadStudentData();
      }
    });
  }

  Future<List<Student>> _loadStudentData() async {
    final currentUser = _authService.currentUser;
    final parentEmail = currentUser?.email;
    if (parentEmail != null) {
      return await _firestoreService.getStudentsByParentEmail(parentEmail);
    }
    return [];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    if (_userType == UserType.admin || _userType == UserType.teacher) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'In/Out'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fees'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'All'),
      ];
    } else {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fees'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }
  }

  Widget _buildScaffold(List<Widget> pages) {
    return Scaffold(
      drawer: (_userType == UserType.admin || _userType == UserType.teacher) ? GlobalDrawer() : null,
      backgroundColor: ColorManager.lightCoolGrey,
      appBar: AppBar(title: const Text('Wisdom Tutorials')),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: ColorManager.tealAccent,
        unselectedItemColor: ColorManager.charcoalGray,
        backgroundColor: ColorManager.lightCoolGrey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: _bottomNavItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userType == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userType == UserType.admin) {
      final adminPages = [
        const _DashboardTab(),
        const AttendanceListScreen(userType: UserType.admin),
        HolidaysScreen(userType: UserType.admin),
        StudentsFeesListScreen(),
        const AllStudentsScreen(),
      ];
      return _buildScaffold(adminPages);
    }

    if (_userType == UserType.teacher) {
      final teacherPages = [
        const _DashboardTab(),
        const AttendanceListScreen(userType: UserType.teacher),
        HolidaysScreen(userType: UserType.teacher),
        StudentsFeesListScreen(),
        const AllStudentsScreen(),
      ];
      return _buildScaffold(teacherPages);
    }

    // parent: use FutureBuilder to load students
    return FutureBuilder<List<Student>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final students = snapshot.data ?? [];
        if (students.isEmpty) {
          return const Scaffold(body: Center(child: Text('No student data found')));
        }

        final studentPages = [
          const _DashboardTab(),
          AttendanceCalendarScreen(
            students: students,
            userType: _userType!,
          ),

          HolidaysScreen(userType: _userType!),
          StudentPaymentScreen(student: students.first, userType: _userType!),
          ProfileScreen(students: students),
        ];
        return _buildScaffold(studentPages);
      },
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = _monthName(now.month);
    final year = now.year;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: ColorManager.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: ColorManager.darkCharcoal, size: 36),
                  const SizedBox(width: 16),
                  Text('$monthName $year Attendance',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: ColorManager.charcoalGray),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month - 1];
  }
}


