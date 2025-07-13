import 'package:flutter/material.dart';
import 'package:wisdom_management_app/constants/user_type.dart';
import 'package:wisdom_management_app/screens/tabs/all_students/all_student_screen.dart';
import 'package:wisdom_management_app/screens/tabs/profile/profile_screen.dart';
import '../../../models/attendance_model/monthly_attendance.dart';
import '../../../models/new_student_model/new_student.dart';
import '../../../theme/color_manager.dart';
import '../../../widgets /global_drawer/global_drawer.dart';
import '../attendance/attendance_screen.dart';
import '../holiday/holiday_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserType userType;

  const HomeScreen({super.key, required this.userType});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final Student dummyStudent = Student(
      uuid: '123-abc',
      name: 'DummyAccount',
      school: 'School',
      studentClass: 'studentClass',
      address: 'address',
      fatherPhone: 'fatherPhone',
      motherPhone: 'motherPhone',
      dob: DateTime(2010, 5, 15),
      joined: DateTime(2010, 5, 15),
      type: UserType.student) ;

  List<Widget> get _pages {
    if (widget.userType == UserType.admin) {
      return [
        const _DashboardTab(),
        const AttendanceScreen(),
        HolidaysScreen(userType: widget.userType),
        const Center(child: Text('Fees Placeholder')),
        const AllStudentsScreen(),
        ProfileScreen(student: dummyStudent),
      ];
    } else {
      return [
        const _DashboardTab(),
        const AttendanceScreen(),
        HolidaysScreen(userType: widget.userType),
        ProfileScreen(student: dummyStudent),
      ];
    }
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    if (widget.userType == UserType.admin) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Fees'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'All'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Holidays'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.userType == UserType.admin ? const GlobalDrawer() : null, // 👈 show only if admin
      backgroundColor: ColorManager.lightCoolGrey,
      appBar: AppBar(
        title: const Text('Wisdom Tutorials'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: ColorManager.burntOrange,
        unselectedItemColor: ColorManager.goldenSand,
        backgroundColor: ColorManager.lightCoolGrey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: _bottomNavItems,
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String currentMonthName = _monthName(now.month);
    final int currentYear = now.year;

    final List<MonthlyAttendance> dummyAttendanceData = [
      MonthlyAttendance(
        month: 'July',
        year: 2025,
        presentDays: [1, 3, 5, 7, 9, 11, 13, 15, 17, 20],
      ),
    ];

    final MonthlyAttendance? currentAttendance = dummyAttendanceData.firstWhere(
          (record) => record.month == currentMonthName && record.year == currentYear,
      orElse: () => MonthlyAttendance(month: currentMonthName, year: currentYear, presentDays: []),
    );

    final int totalDays = DateUtils.getDaysInMonth(now.year, now.month);
    final int presentCount = currentAttendance!.presentDays.length;

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
                  Icon(Icons.check_circle, color: ColorManager.darkMint, size: 36),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$currentMonthName $currentYear Attendance',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$presentCount / $totalDays days present',
                        style: TextStyle(
                          color: ColorManager.burntOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: ColorManager.goldenSand),
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
