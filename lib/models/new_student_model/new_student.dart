import 'dart:convert';


import '../../utils/UserType.dart';



/// ✅ Helper to convert enum to string
String userTypeToString(UserType type) {
  return type.toString().split('.').last;
}

/// ✅ Helper to convert string to enum
UserType userTypeFromString(String str) {
  return UserType.values.firstWhere((e) => e.toString().split('.').last == str,
      orElse: () => UserType.parent);
}

class Student {
  final String uuid;

  final String firstName;
  final String? middleName; // optional
  final String lastName;

  final String studentClass;
  final String school;
  final DateTime dob;
  final DateTime joined; // admission date
  final String fatherPhone;
  final String motherPhone;
  final String address;
  final String? parentEmail;

  final double yearlyFeeTarget; // e.g., ₹30000
  final String? remarks; // optional

  /// ✅ new field
  final UserType userType;

  Student({
    required this.uuid,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.studentClass,
    required this.school,
    required this.dob,
    required this.joined,
    required this.fatherPhone,
    required this.motherPhone,
    required this.address,
    this.parentEmail,
    required this.yearlyFeeTarget,
    this.remarks,
    this.userType = UserType.parent, // default to parent
  });

  /// ✅ Combine into full name if needed
  String get fullName {
    if (middleName != null && middleName!.isNotEmpty) {
      return '$firstName $middleName $lastName';
    }
    return '$firstName $lastName';
  }

  /// ✅ copyWith
  Student copyWith({
    String? uuid,
    String? firstName,
    String? middleName,
    String? lastName,
    String? studentClass,
    String? school,
    DateTime? dob,
    DateTime? joined,
    String? fatherPhone,
    String? motherPhone,
    String? address,
    String? parentEmail,
    double? yearlyFeeTarget,
    String? remarks,
    UserType? userType,
  }) {
    return Student(
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      studentClass: studentClass ?? this.studentClass,
      school: school ?? this.school,
      dob: dob ?? this.dob,
      joined: joined ?? this.joined,
      fatherPhone: fatherPhone ?? this.fatherPhone,
      motherPhone: motherPhone ?? this.motherPhone,
      address: address ?? this.address,
      parentEmail: parentEmail ?? this.parentEmail,
      yearlyFeeTarget: yearlyFeeTarget ?? this.yearlyFeeTarget,
      remarks: remarks ?? this.remarks,
      userType: userType ?? this.userType,
    );
  }

  /// ✅ fromMap (Firestore / DB)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      uuid: map['uuid'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'], // nullable
      lastName: map['lastName'] ?? '',
      studentClass: map['studentClass'] ?? '',
      school: map['school'] ?? '',
      dob: DateTime.parse(map['dob']),
      joined: DateTime.parse(map['joined']),
      fatherPhone: map['fatherPhone'] ?? '',
      motherPhone: map['motherPhone'] ?? '',
      address: map['address'] ?? '',
      parentEmail: map['parentEmail'],
      yearlyFeeTarget: (map['yearlyFeeTarget'] ?? 0).toDouble(),
      remarks: map['remarks'],
      userType: map['userType'] != null
          ? userTypeFromString(map['userType'])
          : UserType.parent, // default
    );
  }

  /// ✅ toMap (Firestore / DB)
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'studentClass': studentClass,
      'school': school,
      'dob': dob.toIso8601String(),
      'joined': joined.toIso8601String(),
      'fatherPhone': fatherPhone,
      'motherPhone': motherPhone,
      'address': address,
      'parentEmail': parentEmail,
      'yearlyFeeTarget': yearlyFeeTarget,
      'remarks': remarks,
      'userType': userTypeToString(userType),
    };
  }

  /// ✅ JSON helpers
  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
