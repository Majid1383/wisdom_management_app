// import 'package:flutter/material.dart';
// import 'color_manager.dart';
//
// class ThemeManager {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       scaffoldBackgroundColor: ColorManager.lightCoolGrey,
//       primaryColor: ColorManager.tealAccent,
//
//       appBarTheme: AppBarTheme(
//         backgroundColor: ColorManager.tealAccent,
//         foregroundColor: ColorManager.lightCoolGrey,
//         elevation: 0,
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//
//       textTheme: const TextTheme(
//         headlineLarge: TextStyle(
//           color: ColorManager.tealAccent,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//         ),
//         bodyLarge: TextStyle(
//           color: ColorManager.charcoalGray,
//           fontSize: 16,
//         ),
//         bodyMedium: TextStyle(
//           color: ColorManager.mintGreen,
//           fontSize: 14,
//         ),
//         labelSmall: TextStyle(
//           color: ColorManager.tealAccent,
//         ),
//       ),
//
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: ColorManager.tealAccent,
//           foregroundColor: Colors.white,
//           textStyle: const TextStyle(fontWeight: FontWeight.bold),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//         ),
//       ),
//
//       inputDecorationTheme: InputDecorationTheme(
//         labelStyle: const TextStyle(color: ColorManager.charcoalGray),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: ColorManager.tealAccent),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'color_manager.dart';

class ThemeManager {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: ColorManager.lightCoolGrey,
      primaryColor: ColorManager.tealAccent,

      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.tealAccent,
        foregroundColor: ColorManager.lightCoolGrey,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: ColorManager.tealAccent,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: ColorManager.charcoalGray,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: ColorManager.mintGreen,
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          color: ColorManager.tealAccent,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.tealAccent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: ColorManager.charcoalGray),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorManager.tealAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),


      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorManager.tealAccent,
        selectionColor: ColorManager.tealAccent.withOpacity(0.3),
        selectionHandleColor: ColorManager.tealAccent,
      ),

      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: ColorManager.tealAccent,
        todayBackgroundColor: MaterialStateProperty.all(ColorManager.tealAccent.withOpacity(0.8)),
        dayForegroundColor: MaterialStateProperty.all(Colors.black),
      ),
    );
  }
}

