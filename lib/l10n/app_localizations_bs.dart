// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Širite dobro';

  @override
  String get shareWithUsSubtitle => 'Podijelite s prijateljem';

  @override
  String get rateApp => 'Ocijenite Zikrove';

  @override
  String get rateAppSubtitle => 'Ostavite kratku recenziju';

  @override
  String get previous => 'Prethodno';

  @override
  String get next => 'Sljedeće';

  @override
  String pageCounter(String current, String total) {
    return '$current od $total';
  }

  @override
  String get done => 'Gotovo ✓';

  @override
  String get addToFavorites => 'Dodaj u omiljeno';

  @override
  String get removeFromFavorites => 'Ukloni iz omiljenog';

  @override
  String get favorites => 'Omiljeno';

  @override
  String get allCategories => 'Sve kategorije';

  @override
  String get exitConfirmationTitle => 'Napustiti učenje?';

  @override
  String get exitConfirmationBody =>
      'Vaš napredak će biti izgubljen. Jeste li sigurni da želite izaći?';

  @override
  String get cancel => 'Otkaži';

  @override
  String get exit => 'Izađi';

  @override
  String get ok => 'U redu';

  @override
  String get fontSize => 'Veličina fonta';

  @override
  String get sampleText => 'Primjer teksta';

  @override
  String get language => 'Jezik';

  @override
  String get shareAppSubject =>
      'Zikrovi — Jutarnji i večernji zikrovi jednostavno';

  @override
  String get shareAppBody =>
      '🤲 Zikrovi — Jutarnji i večernji zikrovi jednostavno\n\nBesplatna aplikacija koja vam pomaže da redovno učite svakodnevne zikrove iz Hisnul Muslima.\n\n✨ Mogućnosti:\n• Jutarnji i večernji zikrovi\n• Zikrovi pri lijeganju i ustajanju\n• Brojanje dodirom\n• Radi i bez interneta\n• Potpuno besplatno, bez reklama\n\nPreuzmite sada:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Postavke';

  @override
  String get settingsDisplay => 'Prikaz';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsTheme => 'Tamni način';

  @override
  String get searchHint => 'Pretražite zikrove';

  @override
  String get searchNoResults => 'Nema rezultata';

  @override
  String get audioPlay => 'Pusti učenje';

  @override
  String get audioStop => 'Zaustavi učenje';

  @override
  String get audioDownloadFailed =>
      'Nije moguće učitati audio. Provjerite vezu.';

  @override
  String get onboardingWelcome => 'Dobrodošli u Zikrove';

  @override
  String get onboardingDescription =>
      'Svakodnevni zikrovi iz Hisnul Muslima, na vašem jeziku.';

  @override
  String get onboardingPickLanguage => 'Odaberite svoj jezik';

  @override
  String get onboardingTapToCountTitle => 'Dodirnite za brojanje';

  @override
  String get onboardingTapToCountBody =>
      'Dodirnite karticu zikra da povećate brojač. Po završetku se automatski prebacuje na sljedeći zikr.';

  @override
  String get onboardingSwipeTitle => 'Koristite dugmad za kretanje';

  @override
  String get onboardingSwipeBody =>
      'Dodirnite Prethodno i Sljedeće za kretanje među zikrovima u kategoriji.';

  @override
  String get onboardingContinue => 'Nastavi';

  @override
  String get onboardingGetStarted => 'Započni';

  @override
  String get notificationMorningTitle => 'Vrijeme je za jutarnje zikrove';

  @override
  String get notificationMorningBody =>
      'Kratak trenutak da započneš dan zikrom.';

  @override
  String get notificationEveningTitle => 'Vrijeme je za večernje zikrove';

  @override
  String get notificationEveningBody =>
      'Kratak trenutak da započneš veče zikrom.';

  @override
  String get notificationsScreenTitle => 'Podsjetnici';

  @override
  String get notificationsScreenIntro =>
      'Tihi dnevni podsjetnici za jutarnje i večernje zikrove.';

  @override
  String get notificationsMorningLabel => 'Jutarnji zikrovi';

  @override
  String get notificationsEveningLabel => 'Večernji zikrovi';

  @override
  String get notificationsChannelName => 'Podsjetnici za zikrove';

  @override
  String get notificationsPermissionDenied =>
      'Obavještenja su isključena u postavkama uređaja.';

  @override
  String get notificationsPermissionDeniedAction => 'Otvori postavke';

  @override
  String get notificationsBatteryHelperTitle => 'Pouzdana isporuka';

  @override
  String get notificationsBatteryHelperBody =>
      'Dozvolite Azkaru da radi u pozadini kako bi podsjetnici stizali na vrijeme.';

  @override
  String get notificationsBatteryHelperAction => 'Dozvoli pozadinsku aktivnost';

  @override
  String get notificationsBatteryHelperOemHint =>
      'Na nekim telefonima (Xiaomi, Huawei, Samsung), provjerite postavke uštede baterije ako podsjetnici i dalje ne stižu.';
}
