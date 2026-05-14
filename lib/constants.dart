import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

class Constants {
  // App display title is now derived from AppLocalizations.appTitle —
  // see MaterialApp.onGenerateTitle. Use l10n.appTitle from screens.

  static const String databaseFileName = 'doa_v2.0.sqlite';
  static const String databaseAssetPath = 'assets/doa_v2.0.sqlite';
  // v2 (2026-05-14): category_titles gained `search_title` + index so
  // search can match category names without an in-Dart loop on every
  // keystroke. See migration 027 + build_sqlite.py SCHEMA_VERSION.
  static const int expectedSchemaVersion = 2;

  // DB files from earlier releases — deleted on first launch of v2.
  static const List<String> legacyDatabaseFileNames = [
    'doa_v1.0.sqlite',
    'doa_localized_v1.1.sqlite',
  ];

  /// All locales the app supports. Both the content DB and the chrome (UI
  /// strings) are fully translated for each of these — there is no English
  /// fallback path at runtime.
  static const List<String> supportedLocaleCodes = [
    'ar', 'en', 'id',
    'bn', 'bs', 'es', 'fa', 'ha', 'hi', 'pt', 'so', 'sw', 'th', 'yo', 'zh',
  ];

  /// Locales whose content is laid out right-to-left.
  static const Set<String> rtlLocaleCodes = {'ar', 'fa'};

  static const String defaultLocaleCode = 'ar';

  /// Native-language display name for each supported locale. Used in the
  /// drawer's language affordance and in the locale picker — speakers see
  /// their language in their own script regardless of the current locale.
  static const Map<String, String> localeNativeNames = {
    'ar': 'العربية',
    'en': 'English',
    'id': 'Indonesia',
    'bn': 'বাংলা',
    'bs': 'Bosanski',
    'es': 'Español',
    'fa': 'فارسی',
    'ha': 'Hausa',
    'hi': 'हिन्दी',
    'pt': 'Português',
    'so': 'Soomaali',
    'sw': 'Kiswahili',
    'th': 'ไทย',
    'yo': 'Yorùbá',
    'zh': '中文',
  };
}

class AppTheme {
  static const double fontSize = 20;
  static const String quranFontFamily = 'KFGQPCHAFSUthmanicScript-Regula';

  /// Chrome display face — Latin + Arabic + Persian in one variable
  /// file. Applied to the M3 `displaySmall` + `titleLarge` /
  /// `titleMedium` text-theme slots so app-bar titles, drawer header,
  /// onboarding heroes, and section headers carry distinct identity
  /// regardless of the active locale. Body copy keeps the platform
  /// default for legibility at small sizes.
  static const String displayFontFamily = 'Vazirmatn';

  static const double noteFontSize = 16;

  // Primary palette. Teal is the brand color but deepened from
  // Colors.teal (#009688, the Material-2014 default) to a richer
  // #0F766E so it reads less generic.
  static final MaterialColor primaryColor = MaterialColor(0xFF0F766E, {
    50: Color(0xFFF0FBFA),
    100: Color(0xFFCCEEEA),
    200: Color(0xFF99DDD5),
    300: Color(0xFF66CBC0),
    400: Color(0xFF33BAAB),
    500: Color(0xFF0F766E),
    600: Color(0xFF0D5F58),
    700: Color(0xFF0A4843),
    800: Color(0xFF06302D),
    900: Color(0xFF031816),
  });

  // Warm gold — reserved for completion moments (gilt-manuscript
  // reference) and for the Rate CTA. Pushed deeper than the prior
  // #C99A4C so the hue reads as pigment, not restaurant-menu chrome.
  // Auditor 2026-05-14: "push toward #B8862E (more pigment, less
  // restaurant-menu) and reserve it for one role — completion".
  static final MaterialColor secondaryColor = MaterialColor(0xFFB8862E, {
    50: Color(0xFFFAEFD3),
    100: Color(0xFFF1DCA1),
    200: Color(0xFFE5C470),
    300: Color(0xFFD7AC4D),
    400: Color(0xFFC79A3D),
    500: Color(0xFFB8862E),
    600: Color(0xFF986F25),
    700: Color(0xFF77571C),
    800: Color(0xFF583F13),
    900: Color(0xFF3B2A0C),
  });

  // Rose for the "favorite" affordance — heart fill state.
  static const Color favoriteColor = Color(0xFFC76C5D);

  // Surfaces. Cream background avoids pure-white sterility; cards sit
  // on top of cream with their own white surface + soft shadow.
  static const Color surfaceLight = Color(0xFFFAF7F2);
  static const Color cardLight = Color(0xFFFFFFFF);

  static const MaterialColor mutedColor = Colors.grey;
  static final Color darkMutedColor = Colors.grey.shade600;
  static const Color whiteColor = Colors.white;

  // Dark theme colors.
  static final Color darkPrimary = primaryColor.shade300;
  static final Color darkSecondary = secondaryColor.shade300;
  static const Color darkBackground = Color(0xFF111417);
  // Card surface bumped from #1B2024 to #1E242A so card-vs-background
  // contrast reads cleanly on AMOLED panels at low brightness — the
  // prior ~1.4:1 ratio risked surfaces merging visually.
  static const Color darkCardColor = Color(0xFF1E242A);
  static final Color darkTextPrimary = Colors.white;
  static final Color darkTextSecondary = Colors.grey.shade400;

  /// Semantic palette for light mode — read via `AppColors.of(context)`
  /// in widget code. Registered on `lightTheme` below.
  static final AppColors lightColors = AppColors(
    background: surfaceLight,
    surface: cardLight,
    cardShadow: cardShadowLight,
    cardShadowElevated: cardShadowElevatedLight,
    divider: const Color(0x14141E28), // ~8% ink — matches card-shadow palette
    textPrimary: const Color(0xFF1A1A1A),
    textSecondary: const Color(0xFF707070),
    textTertiary: mutedColor.shade600, // formerly `caption` slot
    iconMuted: mutedColor.shade400,
    // Light-mode accent tint reads at 10% — cream + 10% teal still
    // separates clearly from the surrounding cream.
    accentTintBg: primaryColor.shade600.withValues(alpha: 0.10),
    primary: primaryColor.shade600,
    secondary: secondaryColor,
  );

  /// Semantic palette for dark mode. `textTertiary` collapses toward
  /// `textSecondary` — dark surfaces have less perceptual hierarchy
  /// across mid-contrast text shades, so a 2-tier scale reads better
  /// than 3 in dark.
  static final AppColors darkColors = AppColors(
    background: darkBackground,
    surface: darkCardColor,
    cardShadow: cardShadowDark,
    cardShadowElevated: cardShadowElevatedDark,
    divider: const Color(0x33FFFFFF), // ~20% white — close-to-bg on dark cards
    textPrimary: darkTextPrimary,
    textSecondary: darkTextSecondary,
    textTertiary: darkMutedColor,
    iconMuted: darkTextSecondary,
    // Dark-mode accent tint needs 18% so the tinted patch reads as a
    // surface, not as a faint glow against the near-black background.
    accentTintBg: primaryColor.shade300.withValues(alpha: 0.18),
    primary: primaryColor.shade300,
    secondary: darkSecondary,
  );

  // Card geometry — used by every screen so we change card style once.
  static const double cardRadius = 14;
  static const List<BoxShadow> cardShadowLight = [
    BoxShadow(
      color: Color(0x0F141E28), // ~6% ink
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A141E28), // ~4%
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  static const List<BoxShadow> cardShadowDark = [
    BoxShadow(color: Color(0x33000000), offset: Offset(0, 4), blurRadius: 12),
  ];

  // Elevated card shadow — for selected/completed/active states.
  // Deeper blur + tightly stacked layers create a "lifted" feel without
  // changing the surface color.
  static const List<BoxShadow> cardShadowElevatedLight = [
    BoxShadow(
      color: Color(0x1F141E28), // ~12% ink
      offset: Offset(0, 8),
      blurRadius: 22,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14141E28), // ~8%
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
  static const List<BoxShadow> cardShadowElevatedDark = [
    BoxShadow(color: Color(0x55000000), offset: Offset(0, 8), blurRadius: 22),
    BoxShadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 4),
  ];

  /// The chrome type scale — Material 3 `TextTheme` slots filled with
  /// our actual rendered sizes. Every widget that takes a `style:`
  /// argument should reach into `Theme.of(context).textTheme.X` rather
  /// than typing a `fontSize:` literal. Numbers used to be sprinkled
  /// across files (11, 11.5, 12, 13.5, 14, 15, 15.5, 16, 17, 18, 22) —
  /// audit 2026-05-14 flagged 13 distinct sizes for chrome. This
  /// collapses to 6.
  ///
  /// Slot mapping (most prominent → least):
  ///   displaySmall  26 / 600 — onboarding hero ("Welcome to Azkar")
  ///   titleLarge    20 / 600 — slide titles, drawer header
  ///   titleMedium   17 / 600 — AppBar title, settings-screen titles
  ///   titleSmall    15 / 600 — row labels (reminder, category, CTA)
  ///   bodyMedium    14 / 400 — body copy in cards
  ///   bodySmall     12 / 400 — captions, OEM hints, time chips
  ///
  /// All title slots use the multi-script display family (Vazirmatn);
  /// body slots use the platform default for legibility at small
  /// sizes. Negative `letterSpacing` on titles tightens the optical
  /// rhythm at display sizes.
  static TextTheme _baseTextTheme({required Color color}) {
    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: color,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
        height: 1.25,
      ),
      titleMedium: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: color,
        height: 1.3,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: color,
        height: 1.3,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ).copyWith(surface: surfaceLight),
      scaffoldBackgroundColor: surfaceLight,
      textTheme: _baseTextTheme(color: const Color(0xFF1A1A1A)),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      iconTheme: IconThemeData(color: primaryColor),
      extensions: [lightColors],
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
          foregroundColor: darkPrimary,
          disabledForegroundColor: darkMutedColor,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Color(0xFFE9EEF0),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: _baseTextTheme(color: darkTextPrimary),
      iconTheme: IconThemeData(color: darkTextSecondary),
      extensions: [darkColors],
    );
  }
}
