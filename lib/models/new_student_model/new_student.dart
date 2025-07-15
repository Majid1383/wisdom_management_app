// import '../../constants/user_type.dart';
//
// class Student {
//   final String uuid;
//   final String name;
//   final String school;
//   final String studentClass;
//   final String address;
//   final String parentEmail;
//   final String fatherPhone;
//   final String motherPhone;
//   final DateTime dob;
//   final DateTime joined;
//   final UserType type;
//
//   Student({
//     required this.uuid,
//     required this.name,
//     required this.school,
//     required this.studentClass,
//     required this.address,
//     required this.parentEmail,
//     required this.fatherPhone,
//     required this.motherPhone,
//     required this.dob,
//     required this.joined,
//     required this.type,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'uuid': uuid,
//       'name': name,
//       'school': school,
//       'class': studentClass,
//       'address': address,
//       'parentEmail':parentEmail,
//       'fatherPhone': fatherPhone,
//       'motherPhone': motherPhone,
//       'dob': dob.toIso8601String(),
//       'joined': joined.toIso8601String(),
//       'type': type.name, // save as string: 'admin' or 'student'
//     };
//   }
//
//   factory Student.fromMap(Map<String, dynamic> map) {
//     return Student(
//       uuid: map['uuid'],
//       name: map['name'],
//       school: map['school'],
//       studentClass: map['class'],
//       address: map['address'],
//       parentEmail: map['parentEmail'],
//       fatherPhone: map['fatherPhone'],
//       motherPhone: map['motherPhone'],
//       dob: DateTime.parse(map['dob']),
//       joined: DateTime.parse(map['joined']),
//       type: map['type'] == 'admin' ? UserType.admin : UserType.student,
//     );
//   }
//
//   // Optional helper
//   bool get isAdmin => type == UserType.admin;
// }


import 'dart:convert';

class Student {
  final String uuid;
  final String name;
  final String studentClass;
  final String school;
  final DateTime dob;
  final DateTime joined;
  final String fatherPhone;
  final String motherPhone;
  final String address;
  final String? parentEmail;

  Student({
    required this.uuid,
    required this.name,
    required this.studentClass,
    required this.school,
    required this.dob,
    required this.joined,
    required this.fatherPhone,
    required this.motherPhone,
    required this.address,
    this.parentEmail,
  });

  /// ✅ copyWith to create updated copies
  Student copyWith({
    String? uuid,
    String? name,
    String? studentClass,
    String? school,
    DateTime? dob,
    DateTime? joined,
    String? fatherPhone,
    String? motherPhone,
    String? address,
    String? parentEmail,
  }) {
    return Student(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
      school: school ?? this.school,
      dob: dob ?? this.dob,
      joined: joined ?? this.joined,
      fatherPhone: fatherPhone ?? this.fatherPhone,
      motherPhone: motherPhone ?? this.motherPhone,
      address: address ?? this.address,
      parentEmail: parentEmail ?? this.parentEmail,
    );
  }

  /// ✅ fromMap for Firebase or local storage
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      uuid: map['uuid'] ?? '',
      name: map['name'] ?? '',
      studentClass: map['studentClass'] ?? '',
      school: map['school'] ?? '',
      dob: DateTime.parse(map['dob']),
      joined: DateTime.parse(map['joined']),
      fatherPhone: map['fatherPhone'] ?? '',
      motherPhone: map['motherPhone'] ?? '',
      address: map['address'] ?? '',
      parentEmail: map['parentEmail'],
    );
  }

  /// ✅ toMap for saving to Firebase or SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'studentClass': studentClass,
      'school': school,
      'dob': dob.toIso8601String(),
      'joined': joined.toIso8601String(),
      'fatherPhone': fatherPhone,
      'motherPhone': motherPhone,
      'address': address,
      'parentEmail': parentEmail,
    };
  }

  /// ✅ fromJson if you save/load JSON string
  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source));

  /// ✅ toJson to save as JSON string
  String toJson() => json.encode(toMap());
}

