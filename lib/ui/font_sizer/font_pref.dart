import 'package:shared_preferences/shared_preferences.dart';

class FontSharedPreferences {
  static const String fontSizeKey = 'fontSize';

  // Singleton
  static final FontSharedPreferences _instance =
      FontSharedPreferences._internal();
  factory FontSharedPreferences() => _instance;
  FontSharedPreferences._internal();

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
}
