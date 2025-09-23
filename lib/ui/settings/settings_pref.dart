import 'package:shared_preferences/shared_preferences.dart';

class SettingsSharedPreferences {
  static const String fontSizeKey = 'fontSize';
  static const String isDarkModeKey = 'isDarkMode';

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
}
