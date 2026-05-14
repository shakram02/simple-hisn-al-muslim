// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Somali (`so`).
class AppLocalizationsSo extends AppLocalizations {
  AppLocalizationsSo([String locale = 'so']) : super(locale);

  @override
  String get appTitle => 'Xisnul Muslim';

  @override
  String get shareWithUs => 'Faafi khayrka';

  @override
  String get shareWithUsSubtitle => 'La wadaag saaxiib';

  @override
  String get rateApp => 'Qiimee Azkar';

  @override
  String get rateAppSubtitle => 'Reeb dib-u-eegis gaaban';

  @override
  String get previous => 'Hore';

  @override
  String get next => 'Xiga';

  @override
  String pageCounter(String current, String total) {
    return '$current ka mid ah $total';
  }

  @override
  String get done => 'Waa dhammaaday ✓';

  @override
  String get addToFavorites => 'Ku dar kuwa la jecel yahay';

  @override
  String get removeFromFavorites => 'Ka saar kuwa la jecel yahay';

  @override
  String get favorites => 'Kuwa la jecel yahay';

  @override
  String get allCategories => 'Dhammaan qaybaha';

  @override
  String get exitConfirmationTitle => 'Ma ka baxaysaa kalfadhiga?';

  @override
  String get exitConfirmationBody =>
      'Horumarkaagu wuu lumayaa. Ma hubtaa inaad rabto inaad ka baxdo?';

  @override
  String get cancel => 'Jooji';

  @override
  String get exit => 'Bax';

  @override
  String get ok => 'Hagaag';

  @override
  String get fontSize => 'Cabbirka qoraalka';

  @override
  String get sampleText => 'Tusaale qoraal';

  @override
  String get language => 'Luuqada';

  @override
  String get shareAppSubject => 'Azkar — Adhkaarta subaxa iyo galabta si fudud';

  @override
  String get shareAppBody =>
      '🤲 Azkar — Adhkaarta subaxa iyo galabta si fudud\n\nApp bilaash ah oo ku caawinaysa inaad sii waddo adhkaartaada maalinlaha ah ee Xisnul Muslim.\n\n✨ Astaamaha:\n• Adhkaarta subaxa iyo galabta\n• Adhkaarta hurdada iyo soo jeeda\n• Tirin shukulul ah\n• Wuxuu shaqeeyaa adigoo aan internet ku jirin\n• Bilaash kkamil ah, xayaysiis la\'aan\n\nSoo deji hadda:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Habdhiska';

  @override
  String get settingsDisplay => 'Muuqaalka';

  @override
  String get settingsLanguage => 'Luuqada';

  @override
  String get settingsTheme => 'Habka mugdiga ah';

  @override
  String get searchHint => 'Raadi adhkaar';

  @override
  String get searchNoResults => 'Wax natiijo ah ma jiraan';

  @override
  String get audioPlay => 'Soo dhig akhriska';

  @override
  String get audioStop => 'Jooji akhriska';

  @override
  String get audioDownloadFailed =>
      'Lama soo bandhigi karo codka. Hubi xiriirkaaga.';

  @override
  String get onboardingWelcome => 'Ku soo dhowoow Azkar';

  @override
  String get onboardingDescription =>
      'Adhkaarta maalinlaha ah ee Xisnul Muslim, luuqaddaada.';

  @override
  String get onboardingPickLanguage => 'Dooro luuqaddaada';

  @override
  String get onboardingTapToCountTitle => 'Taabo si aad u tiriso';

  @override
  String get onboardingTapToCountBody =>
      'Taabo kaadhka dhikrka si aad u kordhiso tirinta. Si toos ah ayey ugu wareegtaa kan xiga marka la dhammeeyo.';

  @override
  String get onboardingSwipeTitle => 'Isticmaal badhamada si aad u dhex marto';

  @override
  String get onboardingSwipeBody =>
      'Taabo Hore iyo Xiga si aad u dhex marto adhkaarta qaybta.';

  @override
  String get onboardingContinue => 'Sii wad';

  @override
  String get onboardingGetStarted => 'Bilow';

  @override
  String get notificationMorningTitle => 'Waa wakhtigii adhkaarta subaxa';

  @override
  String get notificationMorningBody =>
      'Daqiiqado yar oo aad maalintaada ku bilowdo adhkaarta.';

  @override
  String get notificationEveningTitle => 'Waa wakhtigii adhkaarta galabta';

  @override
  String get notificationEveningBody =>
      'Daqiiqado yar oo aad galabtaada ku bilowdo adhkaarta.';

  @override
  String get notificationsScreenTitle => 'Xasuusinta';

  @override
  String get notificationsScreenIntro =>
      'Xasuusin aamusan oo adhkaarta subaxa iyo galabta.';

  @override
  String get notificationsMorningLabel => 'Adhkaarta subaxa';

  @override
  String get notificationsEveningLabel => 'Adhkaarta galabta';

  @override
  String get notificationsChannelName => 'Xasuusinta Adhkaarta';

  @override
  String get notificationsPermissionDenied =>
      'Ogeysiisyada waxaa laga damiyay dejinta aaladdaada.';

  @override
  String get notificationsPermissionDeniedAction => 'Fur dejinta';

  @override
  String get notificationsBatteryHelperTitle =>
      'Soo gaarsiin lagu kalsoon yahay';

  @override
  String get notificationsBatteryHelperBody =>
      'U ogolow Azkar inay ka shaqayso gadaal si xasuusinta ay waqtigeeda u soo gaarto.';

  @override
  String get notificationsBatteryHelperAction => 'U ogolow shaqada gadaasha';

  @override
  String get notificationsBatteryHelperOemHint =>
      'Qaar ka mid ah taleefannada (Xiaomi, Huawei, Samsung), eeg dejinta keydinta batariga haddii xasuusinta weli aysan iman.';
}
