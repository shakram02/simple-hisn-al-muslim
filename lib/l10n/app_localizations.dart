import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_so.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_th.dart';
import 'app_localizations_yo.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('bs'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('ha'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('so'),
    Locale('sw'),
    Locale('th'),
    Locale('yo'),
    Locale('zh'),
  ];

  /// App display title in the AppBar and launcher
  ///
  /// In en, this message translates to:
  /// **'Hisnul Muslim'**
  String get appTitle;

  /// Share-app button on the categories screen. Phrased to convey that sharing IS the good deed (per the hadith الدال على الخير كفاعله) — not 'give away your reward'.
  ///
  /// In en, this message translates to:
  /// **'Spread the good'**
  String get shareWithUs;

  /// Secondary text under the Share CTA on the main screen.
  ///
  /// In en, this message translates to:
  /// **'Share with a friend'**
  String get shareWithUsSubtitle;

  /// Rate-the-app CTA on the main screen; opens the Play Store listing.
  ///
  /// In en, this message translates to:
  /// **'Rate Hisnul Muslim'**
  String get rateApp;

  /// Secondary text under the Rate CTA on the main screen.
  ///
  /// In en, this message translates to:
  /// **'Leave a quick review'**
  String get rateAppSubtitle;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Bottom-of-screen page counter on the zikr detail screen
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String pageCounter(String current, String total);

  /// Marker shown when a zikr's repeat count is reached
  ///
  /// In en, this message translates to:
  /// **'Done ✓'**
  String get done;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @exitConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave session?'**
  String get exitConfirmationTitle;

  /// No description provided for @exitConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be lost. Are you sure you want to exit?'**
  String get exitConfirmationBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @sampleText.
  ///
  /// In en, this message translates to:
  /// **'Sample text'**
  String get sampleText;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @shareAppSubject.
  ///
  /// In en, this message translates to:
  /// **'Hisnul Muslim — Easy morning & evening azkar'**
  String get shareAppSubject;

  /// No description provided for @shareAppBody.
  ///
  /// In en, this message translates to:
  /// **'🤲 Hisnul Muslim — Easy morning & evening azkar\n\nA free app that helps you keep up with daily azkar from Hisnul Muslim.\n\n✨ Features:\n• Morning & evening azkar\n• Sleeping & waking azkar\n• Tap-to-count\n• Works offline\n• Completely free, no ads\n\nDownload now:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar'**
  String get shareAppBody;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplay;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsTheme;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search azkar'**
  String get searchHint;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching azkar'**
  String get searchNoResults;

  /// No description provided for @audioPlay.
  ///
  /// In en, this message translates to:
  /// **'Play recitation'**
  String get audioPlay;

  /// No description provided for @audioStop.
  ///
  /// In en, this message translates to:
  /// **'Stop recitation'**
  String get audioStop;

  /// No description provided for @audioDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load audio. Check your connection.'**
  String get audioDownloadFailed;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Hisnul Muslim'**
  String get onboardingWelcome;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily azkar from Hisnul Muslim, in your language.'**
  String get onboardingDescription;

  /// No description provided for @onboardingPickLanguage.
  ///
  /// In en, this message translates to:
  /// **'Pick your language'**
  String get onboardingPickLanguage;

  /// No description provided for @onboardingTapToCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get onboardingTapToCountTitle;

  /// No description provided for @onboardingTapToCountBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the zikr card to advance the counter. It auto-moves to the next one when complete.'**
  String get onboardingTapToCountBody;

  /// No description provided for @onboardingSwipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Use the buttons to navigate'**
  String get onboardingSwipeTitle;

  /// No description provided for @onboardingSwipeBody.
  ///
  /// In en, this message translates to:
  /// **'Tap Previous and Next to move between zikrs in a category.'**
  String get onboardingSwipeBody;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @notificationMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for morning azkar'**
  String get notificationMorningTitle;

  /// No description provided for @notificationMorningBody.
  ///
  /// In en, this message translates to:
  /// **'A quiet moment to begin your day with azkar.'**
  String get notificationMorningBody;

  /// No description provided for @notificationEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for evening azkar'**
  String get notificationEveningTitle;

  /// No description provided for @notificationEveningBody.
  ///
  /// In en, this message translates to:
  /// **'A quiet moment to begin your evening with azkar.'**
  String get notificationEveningBody;

  /// No description provided for @notificationsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsScreenTitle;

  /// No description provided for @notificationsScreenIntro.
  ///
  /// In en, this message translates to:
  /// **'Quiet daily reminders for morning and evening azkar.'**
  String get notificationsScreenIntro;

  /// No description provided for @notificationsMorningLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning azkar'**
  String get notificationsMorningLabel;

  /// No description provided for @notificationsEveningLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening azkar'**
  String get notificationsEveningLabel;

  /// No description provided for @notificationsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Azkar reminders'**
  String get notificationsChannelName;

  /// No description provided for @notificationsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled in your device settings.'**
  String get notificationsPermissionDenied;

  /// No description provided for @notificationsPermissionDeniedAction.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get notificationsPermissionDeniedAction;

  /// No description provided for @notificationsBatteryHelperTitle.
  ///
  /// In en, this message translates to:
  /// **'Reliable delivery'**
  String get notificationsBatteryHelperTitle;

  /// No description provided for @notificationsBatteryHelperBody.
  ///
  /// In en, this message translates to:
  /// **'Let Hisnul Muslim run in the background so reminders fire on time.'**
  String get notificationsBatteryHelperBody;

  /// No description provided for @notificationsBatteryHelperAction.
  ///
  /// In en, this message translates to:
  /// **'Allow background activity'**
  String get notificationsBatteryHelperAction;

  /// No description provided for @notificationsBatteryHelperOemHint.
  ///
  /// In en, this message translates to:
  /// **'On some phones (Xiaomi, Huawei, Samsung), check your battery-saver settings if reminders still miss.'**
  String get notificationsBatteryHelperOemHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'bs',
    'en',
    'es',
    'fa',
    'ha',
    'hi',
    'id',
    'pt',
    'so',
    'sw',
    'th',
    'yo',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'bs':
      return AppLocalizationsBs();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'ha':
      return AppLocalizationsHa();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'so':
      return AppLocalizationsSo();
    case 'sw':
      return AppLocalizationsSw();
    case 'th':
      return AppLocalizationsTh();
    case 'yo':
      return AppLocalizationsYo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
