import 'package:flutter/material.dart';

class AppColors {
  static const primaryBlue = Color(0xFF007AFF);
  static const accentGreen = Color(0xFF1DB954);
  static const midnightBlue = Color(0xFF0A2647);
  static const softWhite = Color(0xFFF5F8FF);
  static const slate = Color(0xFF4F5D75);
  static const lightSlate = Color(0xFF8892A0);
  static const warning = Color(0xFFFFB74D);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.softWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentGreen,
      background: AppColors.softWhite,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.midnightBlue,
      displayColor: AppColors.midnightBlue,
      fontFamily: 'Roboto',
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.midnightBlue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E7FF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E7FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
      labelStyle: const TextStyle(color: AppColors.lightSlate),
      hintStyle: const TextStyle(color: AppColors.lightSlate),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: const Color(0xFFE8F5E9),
      selectedColor: AppColors.accentGreen,
      labelStyle: const TextStyle(color: AppColors.midnightBlue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
  );
}