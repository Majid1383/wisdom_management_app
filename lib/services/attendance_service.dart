import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model/monthly_attendance.dart';


class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection name: "attendance"
  CollectionReference get _attendanceCollection => _firestore.collection('attendance');

  /// Add new attendance
  Future<void> addAttendance(Attendance attendance) async {
    try {
      await _attendanceCollection.doc(attendance.id).set(attendance.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Update existing attendance
  Future<void> updateAttendance(Attendance attendance) async {
    try {
      await _attendanceCollection.doc(attendance.id).update(attendance.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Delete attendance
  Future<void> deleteAttendance(String attendanceId) async {
    try {
      await _attendanceCollection.doc(attendanceId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all attendance records for a student (ordered by date)
  Stream<List<Attendance>> getAttendanceForStudent(String studentId) {
    return _attendanceCollection
        .where('studentId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList());
  }

  /// Get attendance by date range (optional, useful for monthly view)
  Future<List<Attendance>> getAttendanceByDateRange(String studentId, DateTime start, DateTime end) async {
    final query = await _attendanceCollection
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date')
        .get();

    return query.docs.map((doc) {
      return Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
