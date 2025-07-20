import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisdom_management_app/models/holiday_model/holiday_model.dart';

import '../models/attendance_model/monthly_attendance.dart';
import '../models/new_student_model/new_student.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _attendanceCollection =
  FirebaseFirestore.instance.collection('attendance');

  Future<void> addStudent(Student student) async {
    try {
      await _firestore
          .collection('students')
          .doc(student.uuid) // use uuid as document ID
          .set(student.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Optional: get list of students as stream
  Stream<List<Student>> getStudents() {
    return _firestore.collection('students').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Student.fromMap(doc.data());
      }).toList();
    });
  }

  // Optional: get single student by uuid
  Future<Student?> getStudentById(String uuid) async {
    final doc = await _firestore.collection('students').doc(uuid).get();
    if (doc.exists) {
      return Student.fromMap(doc.data()!);
    }
    return null;
  }

  //get Student by parent email
  Future<List<Student>> getStudentsByParentEmail(String parentEmail) async {
    final query = await _firestore
        .collection('students')
        .where('parentEmail', isEqualTo: parentEmail)
        .get();

    return query.docs.map((doc) => Student.fromMap(doc.data())).toList();
  }

  //get All Student
  Stream<List<Student>> getAllStudents() {
    return _firestore.collection('students').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Student.fromMap(doc.data())).toList();
    });
  }

//Edit Student Data
  Future<void> updateStudent(Student student) async {
    await _firestore.collection('students').doc(student.uuid).update(student.toMap());
  }


  /// Fetch attendance by date range for a student
  Future<List<Attendance>> getAttendanceByDateRange(
      String studentId,
      DateTime startDate,
      DateTime endDate,
      ) async {
    final querySnapshot = await _attendanceCollection
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date')
        .get();

    return querySnapshot.docs.map((doc) {
      return Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }


  Future<List<Attendance>> getMonthlyAttendance(String studentId, DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59); // last day

    final querySnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    return querySnapshot.docs.map((doc) {
      return Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }


}

