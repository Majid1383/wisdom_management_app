class MonthlyAttendance {
  final String month;
  final int year;
  final List<int> presentDays;

  MonthlyAttendance({
    required this.month,
    required this.year,
    required this.presentDays,
  });

  // Optional: For Firebase compatibility
  factory MonthlyAttendance.fromMap(Map<String, dynamic> data) {
    return MonthlyAttendance(
      month: data['month'],
      year: data['year'],
      presentDays: List<int>.from(data['presentDays']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'year': year,
      'presentDays': presentDays,
    };
  }
}
