// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Sambaza kheri';

  @override
  String get shareWithUsSubtitle => 'Shiriki na rafiki';

  @override
  String get rateApp => 'Kadiria Adhkar';

  @override
  String get rateAppSubtitle => 'Acha hakiki fupi';

  @override
  String get previous => 'Iliyotangulia';

  @override
  String get next => 'Inayofuata';

  @override
  String pageCounter(String current, String total) {
    return '$current kati ya $total';
  }

  @override
  String get done => 'Imekamilika ✓';

  @override
  String get addToFavorites => 'Ongeza kwenye vipendwa';

  @override
  String get removeFromFavorites => 'Ondoa kwenye vipendwa';

  @override
  String get favorites => 'Vipendwa';

  @override
  String get allCategories => 'Aina zote';

  @override
  String get exitConfirmationTitle => 'Toka kwenye kipindi?';

  @override
  String get exitConfirmationBody =>
      'Maendeleo yako yatapotea. Una uhakika unataka kutoka?';

  @override
  String get cancel => 'Ghairi';

  @override
  String get exit => 'Toka';

  @override
  String get ok => 'Sawa';

  @override
  String get fontSize => 'Ukubwa wa herufi';

  @override
  String get sampleText => 'Maandishi ya mfano';

  @override
  String get language => 'Lugha';

  @override
  String get shareAppSubject =>
      'Adhkar — Adhkar za asubuhi na jioni kwa urahisi';

  @override
  String get shareAppBody =>
      '🤲 Adhkar — Adhkar za asubuhi na jioni kwa urahisi\n\nProgramu ya bure inayokusaidia kuendelea na adhkar zako za kila siku kutoka Hisnul Muslim.\n\n✨ Vipengele:\n• Adhkar za asubuhi na jioni\n• Adhkar za kulala na kuamka\n• Hesabu kwa kugusa\n• Inafanya kazi bila intaneti\n• Bure kabisa, bila matangazo\n\nPakua sasa:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Mipangilio';

  @override
  String get settingsDisplay => 'Onyesho';

  @override
  String get settingsLanguage => 'Lugha';

  @override
  String get settingsTheme => 'Hali ya giza';

  @override
  String get searchHint => 'Tafuta adhkar';

  @override
  String get searchNoResults => 'Hakuna matokeo';

  @override
  String get audioPlay => 'Cheza kisomo';

  @override
  String get audioStop => 'Simamisha kisomo';

  @override
  String get audioDownloadFailed =>
      'Imeshindwa kupakia sauti. Angalia muunganisho wako.';

  @override
  String get onboardingWelcome => 'Karibu kwenye Adhkar';

  @override
  String get onboardingDescription =>
      'Adhkar za kila siku kutoka Hisnul Muslim, kwa lugha yako.';

  @override
  String get onboardingPickLanguage => 'Chagua lugha yako';

  @override
  String get onboardingTapToCountTitle => 'Gusa kuhesabu';

  @override
  String get onboardingTapToCountBody =>
      'Gusa kadi ya dhikr ili kuongeza kihesabu. Itahamia kwa dhikr inayofuata moja kwa moja ikikamilika.';

  @override
  String get onboardingSwipeTitle => 'Tumia vitufe kupita';

  @override
  String get onboardingSwipeBody =>
      'Gusa Iliyotangulia na Inayofuata ili kuhama kati ya adhkar katika kundi.';

  @override
  String get onboardingContinue => 'Endelea';

  @override
  String get onboardingGetStarted => 'Anza';

  @override
  String get notificationMorningTitle => 'Muda wa adhkar za asubuhi';

  @override
  String get notificationMorningBody =>
      'Dakika chache za kuanza siku yako kwa adhkar.';

  @override
  String get notificationEveningTitle => 'Muda wa adhkar za jioni';

  @override
  String get notificationEveningBody =>
      'Dakika chache za kuanza jioni yako kwa adhkar.';

  @override
  String get notificationsScreenTitle => 'Vikumbusho';

  @override
  String get notificationsScreenIntro =>
      'Vikumbusho vya kimya kwa adhkar za asubuhi na jioni.';

  @override
  String get notificationsMorningLabel => 'Adhkar za asubuhi';

  @override
  String get notificationsEveningLabel => 'Adhkar za jioni';

  @override
  String get notificationsChannelName => 'Vikumbusho vya Adhkar';

  @override
  String get notificationsPermissionDenied =>
      'Arifa zimezimwa katika mipangilio ya kifaa chako.';

  @override
  String get notificationsPermissionDeniedAction => 'Fungua mipangilio';

  @override
  String get notificationsBatteryHelperTitle => 'Utoaji wa kuaminika';

  @override
  String get notificationsBatteryHelperBody =>
      'Ruhusu Azkar kuendesha chinichini ili vikumbusho vifike kwa wakati.';

  @override
  String get notificationsBatteryHelperAction =>
      'Ruhusu shughuli za chinichini';

  @override
  String get notificationsBatteryHelperOemHint =>
      'Kwenye simu fulani (Xiaomi, Huawei, Samsung), angalia mipangilio ya kuhifadhi betri ikiwa vikumbusho bado havifiki.';
}
