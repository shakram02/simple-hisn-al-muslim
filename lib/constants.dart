import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'أذكار المسلم';
  static const String databaseName = 'doa_v1.0.sqlite';
}

class AppTheme {
  static const double fontSize = 20;
  static const String quranFontFamily = 'KFGQPCHAFSUthmanicScript-Regula';

  static const double noteFontSize = 16;

  static final MaterialColor primaryColor = Colors.teal;
  static final MaterialColor secondaryColor = MaterialColor(0xFF963000, {
    50: Color(0xFFF9E6E0),
    100: Color(0xFFF0C0B3),
    200: Color(0xFFE69680),
    300: Color(0xFFE96544),
    400: Color(0xFFC23C16),
    500: Color(0xFF963000),
    600: Color(0xFF6B1D00),
    700: Color(0xFF440D00),
    800: Color(0xFF220600),
    900: Color(0xFF000000),
  });

  static const MaterialColor mutedColor = Colors.grey;
  static final Color darkMutedColor = Colors.grey.shade600;
  static const Color whiteColor = Colors.white;

  // Dark theme colors
  static final Color darkPrimary =
      Colors.teal.shade300; // Lighter teal for dark mode
  static final Color darkSecondary = secondaryColor.shade300;
  static final Color darkBackground = Colors.grey.shade900;
  static final Color darkSurface = Colors.grey.shade800;
  static final Color darkCardColor = Colors.grey.shade700;
  static final Color darkTextPrimary = Colors.white;
  static final Color darkTextSecondary = Colors.grey.shade400;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: primaryColor,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 20),
        bodyMedium: TextStyle(fontSize: 18),
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: secondaryColor),
      ),
      iconTheme: IconThemeData(color: secondaryColor),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: primaryColor,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCardColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkSecondary,
          disabledForegroundColor: darkMutedColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor.shade700,
        foregroundColor: whiteColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 20, color: darkTextPrimary),
        bodyMedium: TextStyle(fontSize: 18, color: darkTextPrimary),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
      ),
      iconTheme: IconThemeData(color: darkTextSecondary),
    );
  }
}
