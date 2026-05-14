import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsSharedPreferences {
  static const String fontSizeKey = 'fontSize';
  static const String isDarkModeKey = 'isDarkMode';
  static const String lastReviewPromptAtKey = 'lastReviewPromptAt';
  static const String firstLaunchAtKey = 'firstLaunchAt';
  static const String localeKey = 'locale';
  static const String favoritesKey = 'favoriteCategoryIds';
  static const String onboardingCompletedKey = 'onboardingCompleted';
  static const String morningReminderEnabledKey = 'morningReminderEnabled';
  static const String morningReminderTimeKey = 'morningReminderTime';
  static const String eveningReminderEnabledKey = 'eveningReminderEnabled';
  static const String eveningReminderTimeKey = 'eveningReminderTime';

  // Defaults for first-time users. Chosen to fall comfortably between
  // Fajr/sunrise and Asr/Maghrib year-round in most populated regions.
  static const TimeOfDay defaultMorningTime = TimeOfDay(hour: 6, minute: 0);
  static const TimeOfDay defaultEveningTime = TimeOfDay(hour: 17, minute: 0);

  // Singleton
  static final SettingsSharedPreferences _instance =
      SettingsSharedPreferences._internal();
  factory SettingsSharedPreferences() => _instance;
  SettingsSharedPreferences._internal();

  // SharedPreferences instance
  SharedPreferences? _prefs;

  Future<double?> getFontSize() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getDouble(fontSizeKey);
  }

  Future<void> saveFontSize(double fontSize) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setDouble(fontSizeKey, fontSize);
  }

  Future<bool?> getIsDarkMode() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool(isDarkModeKey);
  }

  Future<void> saveIsDarkMode(bool isDarkMode) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(isDarkModeKey, isDarkMode);
  }

  Future<DateTime?> getLastReviewPromptAt() async {
    _prefs ??= await SharedPreferences.getInstance();
    final millis = _prefs!.getInt(lastReviewPromptAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> saveLastReviewPromptAt(DateTime when) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setInt(lastReviewPromptAtKey, when.millisecondsSinceEpoch);
  }

  Future<DateTime?> getFirstLaunchAt() async {
    _prefs ??= await SharedPreferences.getInstance();
    final millis = _prefs!.getInt(firstLaunchAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> saveFirstLaunchAt(DateTime when) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setInt(firstLaunchAtKey, when.millisecondsSinceEpoch);
  }

  Future<String?> getLocale() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(localeKey);
  }

  Future<void> saveLocale(String code) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(localeKey, code);
  }

  // Favorites are stored as a String list of category IDs, ordered
  // newest-first so the UI can show recently favorited categories on top.
  Future<List<int>> getFavoriteCategoryIds() async {
    _prefs ??= await SharedPreferences.getInstance();
    final raw = _prefs!.getStringList(favoritesKey) ?? const [];
    return raw.map(int.parse).toList();
  }

  Future<void> addFavorite(int categoryId) async {
    _prefs ??= await SharedPreferences.getInstance();
    final current = _prefs!.getStringList(favoritesKey) ?? [];
    final asString = categoryId.toString();
    if (current.contains(asString)) return;
    await _prefs!.setStringList(favoritesKey, [asString, ...current]);
  }

  Future<void> removeFavorite(int categoryId) async {
    _prefs ??= await SharedPreferences.getInstance();
    final current = _prefs!.getStringList(favoritesKey) ?? [];
    final asString = categoryId.toString();
    if (!current.contains(asString)) return;
    final next = current.where((s) => s != asString).toList();
    await _prefs!.setStringList(favoritesKey, next);
  }

  /// Sugar for "save and propagate font size from drawer/quick action".
  /// The drawer's slider invokes this on `onChangeEnd` so the user's
  /// chosen size persists without needing to open the dialog.
  Future<void> persistFontSize(double size) => saveFontSize(size);

  Future<bool?> getOnboardingCompleted() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool(onboardingCompletedKey);
  }

  Future<void> saveOnboardingCompleted(bool completed) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(onboardingCompletedKey, completed);
  }

  // ─── Reminder preferences (azkar-notifications capability) ───────

  Future<bool> getMorningReminderEnabled() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool(morningReminderEnabledKey) ?? false;
  }

  Future<void> saveMorningReminderEnabled(bool enabled) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(morningReminderEnabledKey, enabled);
  }

  Future<TimeOfDay> getMorningReminderTime() async {
    return _readTime(morningReminderTimeKey, defaultMorningTime);
  }

  Future<void> saveMorningReminderTime(TimeOfDay time) async {
    await _writeTime(morningReminderTimeKey, time);
  }

  Future<bool> getEveningReminderEnabled() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool(eveningReminderEnabledKey) ?? false;
  }

  Future<void> saveEveningReminderEnabled(bool enabled) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(eveningReminderEnabledKey, enabled);
  }

  Future<TimeOfDay> getEveningReminderTime() async {
    return _readTime(eveningReminderTimeKey, defaultEveningTime);
  }

  Future<void> saveEveningReminderTime(TimeOfDay time) async {
    await _writeTime(eveningReminderTimeKey, time);
  }

  /// Store as "HH:MM" — locale-independent (always 24h), human-readable
  /// in the on-disk XML, trivially parseable.
  Future<void> _writeTime(String key, TimeOfDay time) async {
    _prefs ??= await SharedPreferences.getInstance();
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    await _prefs!.setString(key, formatted);
  }

  Future<TimeOfDay> _readTime(String key, TimeOfDay fallback) async {
    _prefs ??= await SharedPreferences.getInstance();
    final raw = _prefs!.getString(key);
    if (raw == null) return fallback;
    final parts = raw.split(':');
    if (parts.length != 2) return fallback;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return fallback;
    if (h < 0 || h > 23 || m < 0 || m > 59) return fallback;
    return TimeOfDay(hour: h, minute: m);
  }
}
