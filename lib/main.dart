import 'package:azkar/constants.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/app_bar.dart';
import 'package:azkar/ui/category_list/screen.dart';
import 'package:azkar/ui/settings/dialog.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:azkar/ui/zikr_category/screen.dart';
import 'package:flutter/material.dart';

const String locale = 'ar';

void main() {
  runApp(const ZikrApp());
}

class ZikrApp extends StatefulWidget {
  const ZikrApp({super.key});

  @override
  State<ZikrApp> createState() => _ZikrAppState();
}

class _ZikrAppState extends State<ZikrApp> {
  double fontSize = AppTheme.fontSize;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void toggleTheme() {
    final newIsDarkMode = !isDarkMode;
    // save the theme to shared preferences

    SettingsSharedPreferences().saveIsDarkMode(newIsDarkMode).then((value) {
      setState(() {
        isDarkMode = newIsDarkMode;
      });
    });
  }

  void changeFontSize(double newSize) {
    setState(() {
      fontSize = newSize;
    });
  }

  void _initializeApp() async {
    final prefFontSize = await SettingsSharedPreferences().getFontSize();
    final prefIsDarkMode = await SettingsSharedPreferences().getIsDarkMode();
    setState(() {
      fontSize = prefFontSize ?? AppTheme.fontSize;
      isDarkMode = prefIsDarkMode ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: CategoriesScreen(
        onThemeToggle: toggleTheme,
        fontSize: fontSize,
        onFontSizeChanged: changeFontSize,
        locale: locale,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
