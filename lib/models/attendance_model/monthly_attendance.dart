import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;            // Firestore document ID (unique per attendance record)
  final String studentId;     // UUID of the student this attendance belongs to
  final String status;        // e.g., 'present', 'absent', 'half'  (you can keep as you need)
  final DateTime date;        // The specific date of this attendance
  final String? note;        // Optional note added by teacher/admin

  Attendance({
    required this.id,
    required this.studentId,
    required this.status,
    required this.date,
    this.note,
  });

  /// Deserialize from Firestore
  factory Attendance.fromMap(Map<String, dynamic> map, String docId) {
    return Attendance(
      id: docId,
      studentId: map['studentId'] ?? '',
      status: map['status'] ?? 'absent',
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'],
    );
  }

  /// Serialize to Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'status': status,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }
}
