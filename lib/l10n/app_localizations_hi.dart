// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हिसनुल मुस्लिम';

  @override
  String get shareWithUs => 'भलाई फैलाएँ';

  @override
  String get shareWithUsSubtitle => 'किसी मित्र के साथ साझा करें';

  @override
  String get rateApp => 'अज़कार को रेट करें';

  @override
  String get rateAppSubtitle => 'एक छोटी समीक्षा छोड़ें';

  @override
  String get previous => 'पिछला';

  @override
  String get next => 'अगला';

  @override
  String pageCounter(String current, String total) {
    return '$total में से $current';
  }

  @override
  String get done => 'हो गया ✓';

  @override
  String get addToFavorites => 'पसंदीदा में जोड़ें';

  @override
  String get removeFromFavorites => 'पसंदीदा से हटाएँ';

  @override
  String get favorites => 'पसंदीदा';

  @override
  String get allCategories => 'सभी श्रेणियाँ';

  @override
  String get exitConfirmationTitle => 'क्या आप बाहर निकलना चाहते हैं?';

  @override
  String get exitConfirmationBody =>
      'आपकी प्रगति खो जाएगी। क्या आप वाकई बाहर निकलना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get ok => 'ठीक है';

  @override
  String get fontSize => 'फ़ॉन्ट का आकार';

  @override
  String get sampleText => 'नमूना पाठ';

  @override
  String get language => 'भाषा';

  @override
  String get shareAppSubject => 'अज़कार — सुबह और शाम के आसान अज़कार';

  @override
  String get shareAppBody =>
      '🤲 अज़कार — सुबह और शाम के आसान अज़कार\n\nएक मुफ़्त ऐप जो आपको हिसनुल मुस्लिम के दैनिक अज़कार पढ़ने में मदद करता है।\n\n✨ विशेषताएँ:\n• सुबह और शाम के अज़कार\n• सोने और जागने के अज़कार\n• टैप करके गिनती\n• ऑफ़लाइन काम करता है\n• पूरी तरह मुफ़्त, बिना विज्ञापन\n\nअभी डाउनलोड करें:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get settingsDisplay => 'डिस्प्ले';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsTheme => 'डार्क मोड';

  @override
  String get searchHint => 'अज़कार खोजें';

  @override
  String get searchNoResults => 'कोई परिणाम नहीं';

  @override
  String get audioPlay => 'तिलावत चलाएँ';

  @override
  String get audioStop => 'तिलावत रोकें';

  @override
  String get audioDownloadFailed =>
      'ऑडियो लोड नहीं हो सका। अपना कनेक्शन जाँचें।';

  @override
  String get onboardingWelcome => 'अज़कार में स्वागत है';

  @override
  String get onboardingDescription =>
      'हिसनुल मुस्लिम के दैनिक अज़कार, आपकी भाषा में।';

  @override
  String get onboardingPickLanguage => 'अपनी भाषा चुनें';

  @override
  String get onboardingTapToCountTitle => 'गिनने के लिए टैप करें';

  @override
  String get onboardingTapToCountBody =>
      'ज़िक्र कार्ड पर टैप करके गिनती बढ़ाएँ। पूरा होने पर अगले ज़िक्र पर अपने आप चला जाएगा।';

  @override
  String get onboardingSwipeTitle => 'नेविगेट करने के लिए बटन का इस्तेमाल करें';

  @override
  String get onboardingSwipeBody =>
      'किसी श्रेणी के ज़िक्रों के बीच जाने के लिए पिछला और अगला बटन दबाएँ।';

  @override
  String get onboardingContinue => 'जारी रखें';

  @override
  String get onboardingGetStarted => 'शुरू करें';

  @override
  String get notificationMorningTitle => 'सुबह के अज़कार का समय हो गया';

  @override
  String get notificationMorningBody =>
      'अज़कार के साथ अपना दिन शुरू करने के लिए कुछ शांत पल।';

  @override
  String get notificationEveningTitle => 'शाम के अज़कार का समय हो गया';

  @override
  String get notificationEveningBody =>
      'अज़कार के साथ अपनी शाम शुरू करने के लिए कुछ शांत पल।';

  @override
  String get notificationsScreenTitle => 'रिमाइंडर';

  @override
  String get notificationsScreenIntro =>
      'सुबह और शाम के अज़कार के लिए शांत रिमाइंडर।';

  @override
  String get notificationsMorningLabel => 'सुबह के अज़कार';

  @override
  String get notificationsEveningLabel => 'शाम के अज़कार';

  @override
  String get notificationsChannelName => 'अज़कार रिमाइंडर';

  @override
  String get notificationsPermissionDenied =>
      'आपके डिवाइस की सेटिंग्स में नोटिफिकेशन बंद हैं।';

  @override
  String get notificationsPermissionDeniedAction => 'सेटिंग्स खोलें';

  @override
  String get notificationsBatteryHelperTitle => 'विश्वसनीय डिलीवरी';

  @override
  String get notificationsBatteryHelperBody =>
      'अज़कार को बैकग्राउंड में चलने दें ताकि रिमाइंडर समय पर आएं।';

  @override
  String get notificationsBatteryHelperAction =>
      'बैकग्राउंड गतिविधि की अनुमति दें';

  @override
  String get notificationsBatteryHelperOemHint =>
      'कुछ फ़ोन (Xiaomi, Huawei, Samsung) में रिमाइंडर मिस होने पर बैटरी सेवर सेटिंग्स देखें।';
}
