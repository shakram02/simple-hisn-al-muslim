import 'package:flutter/widgets.dart';

const String _arabicIndicDigits = '٠١٢٣٤٥٦٧٨٩';

/// Returns [number] using Arabic-Indic digits (e.g. 12 → ١٢).
String arabicNumber(int number) {
  return number
      .toString()
      .split('')
      .map((char) => _arabicIndicDigits[int.parse(char)])
      .join('');
}

/// Returns [number] formatted for [locale]:
///   - Arabic-Indic digits when the locale is Arabic or Persian
///     (Persian uses ۰۱۲۳۴۵۶۷۸۹ which Unicode-renders very close to ٠١٢٣٤٥٦٧٨٩
///      — we don't bother distinguishing them in v1.1).
///   - Western digits everywhere else, including the 12 new HTML-scraped
///     locales whose scripts have their own numeral systems (Bengali, Hindi,
///     Thai, Chinese). We keep the Western form because the chrome falls
///     back to English for those locales, and a mixed numeral system in an
///     English-chrome counter ("1 of ২৪") reads worse than uniform Western.
String localizedNumber(int number, Locale locale) {
  if (locale.languageCode == 'ar' || locale.languageCode == 'fa') {
    return arabicNumber(number);
  }
  return number.toString();
}
