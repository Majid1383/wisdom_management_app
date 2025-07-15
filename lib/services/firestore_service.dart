import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/new_student_model/new_student.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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



}

