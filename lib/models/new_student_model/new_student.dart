import '../../constants/user_type.dart';

class Student {
  final String uuid;
  final String name;
  final String school;
  final String studentClass;
  final String address;
  final String fatherPhone;
  final String motherPhone;
  final DateTime dob;
  final DateTime joined;
  final UserType type;

  Student({
    required this.uuid,
    required this.name,
    required this.school,
    required this.studentClass,
    required this.address,
    required this.fatherPhone,
    required this.motherPhone,
    required this.dob,
    required this.joined,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'school': school,
      'class': studentClass,
      'address': address,
      'fatherPhone': fatherPhone,
      'motherPhone': motherPhone,
      'dob': dob.toIso8601String(),
      'joined': joined.toIso8601String(),
      'type': type.name, // save as string: 'admin' or 'student'
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      uuid: map['uuid'],
      name: map['name'],
      school: map['school'],
      studentClass: map['class'],
      address: map['address'],
      fatherPhone: map['fatherPhone'],
      motherPhone: map['motherPhone'],
      dob: DateTime.parse(map['dob']),
      joined: DateTime.parse(map['joined']),
      type: map['type'] == 'admin' ? UserType.admin : UserType.student,
    );
  }

  // Optional helper
  bool get isAdmin => type == UserType.admin;
}
