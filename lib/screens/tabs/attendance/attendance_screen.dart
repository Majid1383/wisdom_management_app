import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/color_manager.dart';
import '../../../widgets /global_drawer/global_drawer.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    // Generate data for past 6 months
    final List<Widget> monthlyAttendanceGrids = List.generate(6, (index) {
      final DateTime monthDate = DateTime(now.year, now.month - index);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_monthName(monthDate.month)} ${monthDate.year}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ColorManager.burntOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildMonthGrid(monthDate),
          const SizedBox(height: 24),
        ],
      );
    });

    return Scaffold(
      backgroundColor: ColorManager.lightCoolGrey,
      drawer: const GlobalDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...monthlyAttendanceGrids,
            _buildLegendRow(),
          ],
        ),
      ),
    );
  }

  /// Builds the attendance grid for a single month
  static Widget _buildMonthGrid(DateTime date) {
    final int totalDays = DateUtils.getDaysInMonth(date.year, date.month);
    final List<int> presentDays = _generateRandomPresentDays(totalDays);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalDays,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;
        final isPresent = presentDays.contains(day);

        return Container(
          decoration: BoxDecoration(
            color: isPresent ? ColorManager.darkMint : Colors.transparent,
            border: Border.all(
              color: isPresent ? ColorManager.mintGreen : ColorManager.darkMint,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(
              color: isPresent
                  ? ColorManager.goldenSand
                  : ColorManager.goldenSand.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  /// Randomly selects present days from the month
  static List<int> _generateRandomPresentDays(int totalDays) {
    final Random random = Random();
    final int presentCount = totalDays ~/ 2 + random.nextInt(5); // 50–60% days present
    final Set<int> presentDays = {};

    while (presentDays.length < presentCount) {
      presentDays.add(random.nextInt(totalDays) + 1);
    }

    return presentDays.toList();
  }

  /// Month name formatter
  static String _monthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[(month - 1) % 12];
  }

  /// Legend
  static Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendBox(ColorManager.mintGreen, 'Present'),
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
