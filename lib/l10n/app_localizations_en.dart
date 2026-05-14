// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Spread the good';

  @override
  String get shareWithUsSubtitle => 'Share with a friend';

  @override
  String get rateApp => 'Rate Hisnul Muslim';

  @override
  String get rateAppSubtitle => 'Leave a quick review';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String pageCounter(String current, String total) {
    return '$current of $total';
  }

  @override
  String get done => 'Done ✓';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get favorites => 'Favorites';

  @override
  String get allCategories => 'All categories';

  @override
  String get exitConfirmationTitle => 'Leave session?';

  @override
  String get exitConfirmationBody =>
      'Your progress will be lost. Are you sure you want to exit?';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get ok => 'OK';

  @override
  String get fontSize => 'Font size';

  @override
  String get sampleText => 'Sample text';

  @override
  String get language => 'Language';

  @override
  String get shareAppSubject => 'Hisnul Muslim — Easy morning & evening azkar';

  @override
  String get shareAppBody =>
      '🤲 Hisnul Muslim — Easy morning & evening azkar\n\nA free app that helps you keep up with daily azkar from Hisnul Muslim.\n\n✨ Features:\n• Morning & evening azkar\n• Sleeping & waking azkar\n• Tap-to-count\n• Works offline\n• Completely free, no ads\n\nDownload now:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Settings';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Dark mode';

  @override
  String get searchHint => 'Search azkar';

  @override
  String get searchNoResults => 'No matching azkar';

  @override
  String get audioPlay => 'Play recitation';

  @override
  String get audioStop => 'Stop recitation';

  @override
  String get audioDownloadFailed =>
      'Couldn\'t load audio. Check your connection.';

  @override
  String get onboardingWelcome => 'Welcome to Hisnul Muslim';

  @override
  String get onboardingDescription =>
      'Daily azkar from Hisnul Muslim, in your language.';

  @override
  String get onboardingPickLanguage => 'Pick your language';

  @override
  String get onboardingTapToCountTitle => 'Tap to count';

  @override
  String get onboardingTapToCountBody =>
      'Tap the zikr card to advance the counter. It auto-moves to the next one when complete.';

  @override
  String get onboardingSwipeTitle => 'Use the buttons to navigate';

  @override
  String get onboardingSwipeBody =>
      'Tap Previous and Next to move between zikrs in a category.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get notificationMorningTitle => 'Time for morning azkar';

  @override
  String get notificationMorningBody =>
      'A quiet moment to begin your day with azkar.';

  @override
  String get notificationEveningTitle => 'Time for evening azkar';

  @override
  String get notificationEveningBody =>
      'A quiet moment to begin your evening with azkar.';

  @override
  String get notificationsScreenTitle => 'Notifications';

  @override
  String get notificationsScreenIntro =>
      'Quiet daily reminders for morning and evening azkar.';

  @override
  String get notificationsMorningLabel => 'Morning azkar';

  @override
  String get notificationsEveningLabel => 'Evening azkar';

  @override
  String get notificationsChannelName => 'Azkar reminders';

  @override
  String get notificationsPermissionDenied =>
      'Notifications are disabled in your device settings.';

  @override
  String get notificationsPermissionDeniedAction => 'Open settings';

  @override
  String get notificationsBatteryHelperTitle => 'Reliable delivery';

  @override
  String get notificationsBatteryHelperBody =>
      'Let Hisnul Muslim run in the background so reminders fire on time.';

  @override
  String get notificationsBatteryHelperAction => 'Allow background activity';

  @override
  String get notificationsBatteryHelperOemHint =>
      'On some phones (Xiaomi, Huawei, Samsung), check your battery-saver settings if reminders still miss.';
}
