import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'أذكار المسلم';
}

class AppTheme {
  static const double fontSize = 20;
  static const String quranFontFamily = 'KFGQPCHAFSUthmanicScript-Regula';

  static const double noteFontSize = 16;

  static const MaterialColor primaryColor = Colors.teal;
  static const MaterialColor secondaryColor = MaterialColor(0xFF963000, {
    50: Color(0xFFF9E6E0),
    100: Color(0xFFF0C0B3),
    200: Color(0xFFE69680),
    300: Color(0xFFD66649),
    400: Color(0xFFC23C16),
    500: Color(0xFF963000),
    600: Color(0xFF6B1D00),
    700: Color(0xFF440D00),
    800: Color(0xFF220600),
    900: Color(0xFF000000),
  });

  static const MaterialColor mutedColor = Colors.grey;
  static const Color whiteColor = Colors.white;
}
