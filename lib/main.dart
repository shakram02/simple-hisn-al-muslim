import 'dart:ui';

import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/category_list/screen.dart';
import 'package:azkar/ui/onboarding/screen.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';

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
  String localeCode = Constants.defaultLocaleCode;
  bool isBooting = true;
  bool needsOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void toggleTheme() {
    final newIsDarkMode = !isDarkMode;
    SettingsSharedPreferences().saveIsDarkMode(newIsDarkMode).then((_) {
      if (!mounted) return;
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

  void changeLocale(String code) {
    if (code == localeCode) return;
    setState(() {
      localeCode = code;
    });
  }

  void finishOnboarding() {
    setState(() {
      needsOnboarding = false;
    });
  }

  Future<void> _initializeApp() async {
    final prefs = SettingsSharedPreferences();
    final prefFontSize = await prefs.getFontSize();
    final prefIsDarkMode = await prefs.getIsDarkMode();
    final savedLocale = await prefs.getLocale();
    final firstLaunchAt = await prefs.getFirstLaunchAt();
    var onboardingFlag = await prefs.getOnboardingCompleted();

    // Migration: existing v1.0 users (any prior state) skip onboarding.
    if (onboardingFlag == null) {
      final isUpgrader =
          prefFontSize != null ||
          prefIsDarkMode != null ||
          savedLocale != null ||
          firstLaunchAt != null;
      if (isUpgrader) {
        await prefs.saveOnboardingCompleted(true);
        onboardingFlag = true;
      }
    }

    if (!mounted) return;
    setState(() {
      fontSize = prefFontSize ?? AppTheme.fontSize;
      isDarkMode = prefIsDarkMode ?? false;
      localeCode = _resolveInitialLocale(savedLocale);
      needsOnboarding = onboardingFlag != true;
      isBooting = false;
    });
  }

  String _resolveInitialLocale(String? saved) {
    if (saved != null && Constants.supportedLocaleCodes.contains(saved)) {
      return saved;
    }
    final device = PlatformDispatcher.instance.locale.languageCode;
    if (Constants.supportedLocaleCodes.contains(device)) {
      return device;
    }
    return Constants.defaultLocaleCode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: Locale(localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _buildHome(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildHome() {
    if (isBooting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (needsOnboarding) {
      return OnboardingScreen(
        initialLocaleCode: localeCode,
        onLocaleChanged: changeLocale,
        onFinished: finishOnboarding,
      );
    }
    return CategoriesScreen(
      key: ValueKey(localeCode),
      onThemeToggle: toggleTheme,
      isDarkMode: isDarkMode,
      fontSize: fontSize,
      onFontSizeChanged: changeFontSize,
      localeCode: localeCode,
      onLocaleChanged: changeLocale,
    );
  }
}
