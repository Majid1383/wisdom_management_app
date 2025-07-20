import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/holiday_model/holiday_model.dart';

class HolidayService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference holidaysCollection =
  FirebaseFirestore.instance.collection('holidays');

  /// Add holiday and let Firestore auto-generate the ID (old way)
  // Future<void> addHoliday(Holiday holiday) async {
  //   await holidaysCollection.add(holiday.toMap());
  // }

  Future<void> addHoliday(Holiday holiday) async {
    final data = holiday.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await holidaysCollection.add(data);
  }


  /// Add holiday *with* known document ID (recommended for edit/delete)
  Future<void> addHolidayWithId(Holiday holiday) async {
    await holidaysCollection.doc(holiday.id).set(holiday.toMap());
  }

  /// Stream all holidays, sorted by first date (client-side)
  Stream<List<Holiday>> getAllHolidays() {
    return holidaysCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Holiday.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Update holiday
  Future<void> updateHoliday(Holiday holiday) async {
    await holidaysCollection.doc(holiday.id).update(holiday.toMap());
  }

  /// Delete holiday
  Future<void> deleteHoliday(String holidayId) async {
    await holidaysCollection.doc(holidayId).delete();
  }

  Stream<Holiday> getHolidayById(String holidayId) {
    return holidaysCollection.doc(holidayId).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Holiday.fromMap(data, doc.id);
    });
  }

  Stream<Holiday?> getLatestHoliday() {
    return holidaysCollection
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        if (data != null && data is Map<String, dynamic>) {
          return Holiday.fromMap(data, doc.id);
        }
      }
      return null;
    });
  }


  Future<List<DateTime>> getWorkingDays(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    // Fetch holidays from Firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('holidays')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
        .get();

    final holidayDates = querySnapshot.docs.map((doc) {
      return (doc['date'] as Timestamp).toDate();
    }).map((d) => DateTime(d.year, d.month, d.day)).toSet();

    List<DateTime> workingDays = [];

    for (DateTime d = firstDay; !d.isAfter(lastDay); d = d.add(const Duration(days: 1))) {
      if (d.weekday != DateTime.sunday && !holidayDates.contains(DateTime(d.year, d.month, d.day))) {
        workingDays.add(d);
      }
    }

    return workingDays;
  }


}
