
import '../screens/tabs/attendance/attendance_calendar.dart';
import '../utils/UserType.dart';

extension UserTypeExtension on UserType {
  /// Convert enum to string to save in SharedPreferences
  String get name {
    switch (this) {
      case UserType.admin:
        return 'admin';
      case UserType.teacher:
        return 'teacher';
      case UserType.parent:
        return 'parent';
    }
  }

  /// Convert string from SharedPreferences to enum
  static UserType? fromString(String? value) {
    switch (value) {
      case 'admin':
        return UserType.admin;
      case 'teacher':
        return UserType.teacher;
      case 'parent':
        return UserType.parent;
      default:
        return null;
    }
  }
}
