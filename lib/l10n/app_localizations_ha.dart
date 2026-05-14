// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class AppLocalizationsHa extends AppLocalizations {
  AppLocalizationsHa([String locale = 'ha']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Yada alheri';

  @override
  String get shareWithUsSubtitle => 'Raba tare da aboki';

  @override
  String get rateApp => 'Ƙimanta Azkar';

  @override
  String get rateAppSubtitle => 'Bar gajeren sharhi';

  @override
  String get previous => 'Baya';

  @override
  String get next => 'Gaba';

  @override
  String pageCounter(String current, String total) {
    return '$current daga $total';
  }

  @override
  String get done => 'An gama ✓';

  @override
  String get addToFavorites => 'Ƙara cikin abubuwan da na fi so';

  @override
  String get removeFromFavorites => 'Cire daga abubuwan da na fi so';

  @override
  String get favorites => 'Abubuwan da na fi so';

  @override
  String get allCategories => 'Dukan kashe-kashe';

  @override
  String get exitConfirmationTitle => 'Ka fita daga taron?';

  @override
  String get exitConfirmationBody =>
      'Za a rasa abin da ka cim ma. Tabbas kana son fita?';

  @override
  String get cancel => 'Soke';

  @override
  String get exit => 'Fita';

  @override
  String get ok => 'Yarda';

  @override
  String get fontSize => 'Girman rubutu';

  @override
  String get sampleText => 'Rubutun misali';

  @override
  String get language => 'Harshe';

  @override
  String get shareAppSubject => 'Azkar — Adhkar safe da yamma cikin sauƙi';

  @override
  String get shareAppBody =>
      '🤲 Azkar — Adhkar safe da yamma cikin sauƙi\n\nWani manhajar kyauta da ke taimaka maka kiyaye adhkar na yau da kullum daga Hisnul Muslim.\n\n✨ Fasaloli:\n• Adhkar safe da yamma\n• Adhkar na barci da farkawa\n• Lissafi ta hanyar taɓawa\n• Yana aiki ba tare da intanet ba\n• Kyauta kwata-kwata, babu tallace-tallace\n\nSauke shi yanzu:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Saitunan';

  @override
  String get settingsDisplay => 'Nuni';

  @override
  String get settingsLanguage => 'Harshe';

  @override
  String get settingsTheme => 'Yanayin duhu';

  @override
  String get searchHint => 'Nemo adhkar';

  @override
  String get searchNoResults => 'Babu sakamako';

  @override
  String get audioPlay => 'Sauraron karatu';

  @override
  String get audioStop => 'Tsayar da karatu';

  @override
  String get audioDownloadFailed =>
      'An kasa loda sauti. Duba haɗin intanetinka.';

  @override
  String get onboardingWelcome => 'Barka da zuwa Azkar';

  @override
  String get onboardingDescription =>
      'Adhkar na yau da kullum daga Hisnul Muslim, da harshenka.';

  @override
  String get onboardingPickLanguage => 'Zaɓi harshenka';

  @override
  String get onboardingTapToCountTitle => 'Taɓa don kirgawa';

  @override
  String get onboardingTapToCountBody =>
      'Taɓa katin zikiri don ƙara lissafi. Zai matsa zuwa na gaba ta atomatik bayan gama.';

  @override
  String get onboardingSwipeTitle => 'Yi amfani da maɓallai don tafiya';

  @override
  String get onboardingSwipeBody =>
      'Taɓa Baya da Gaba don motsa tsakanin azkar a cikin kashin.';

  @override
  String get onboardingContinue => 'Ci gaba';

  @override
  String get onboardingGetStarted => 'Fara';

  @override
  String get notificationMorningTitle => 'Lokacin azkar safe';

  @override
  String get notificationMorningBody =>
      'Ɗan lokaci na shiru don fara ranar ka da azkar.';

  @override
  String get notificationEveningTitle => 'Lokacin azkar yamma';

  @override
  String get notificationEveningBody =>
      'Ɗan lokaci na shiru don fara maraicen ka da azkar.';

  @override
  String get notificationsScreenTitle => 'Tunatarwa';

  @override
  String get notificationsScreenIntro =>
      'Tunatarwa shiru don azkar safe da yamma.';

  @override
  String get notificationsMorningLabel => 'Azkar safe';

  @override
  String get notificationsEveningLabel => 'Azkar yamma';

  @override
  String get notificationsChannelName => 'Tunatarwa na Azkar';

  @override
  String get notificationsPermissionDenied =>
      'An kashe sanarwar a saitunan na\'urarka.';

  @override
  String get notificationsPermissionDeniedAction => 'Buɗe saitunan';

  @override
  String get notificationsBatteryHelperTitle => 'Aiko abin dogara';

  @override
  String get notificationsBatteryHelperBody =>
      'Bari Azkar ya ci gaba a baya don tunatarwa ta kasance a kan lokaci.';

  @override
  String get notificationsBatteryHelperAction => 'Yarda da ayyukan baya';

  @override
  String get notificationsBatteryHelperOemHint =>
      'A wasu wayoyi (Xiaomi, Huawei, Samsung), duba saitunan ceton batir idan har yanzu tunatarwa ba ta zo ba.';
}
