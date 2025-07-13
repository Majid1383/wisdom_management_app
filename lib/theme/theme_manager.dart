import 'package:flutter/material.dart';
import 'color_manager.dart';

class ThemeManager {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: ColorManager.lightCoolGrey,
      primaryColor: ColorManager.burntOrange,

      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.burntOrange,
        foregroundColor: Colors.white,
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
          color: ColorManager.burntOrange,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: ColorManager.goldenSand,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: ColorManager.mintGreen,
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          color: ColorManager.burntOrange,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.burntOrange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: ColorManager.goldenSand),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorManager.burntOrange),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
