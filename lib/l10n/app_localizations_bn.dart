// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'হিসনুল মুসলিম';

  @override
  String get shareWithUs => 'কল্যাণ ছড়িয়ে দিন';

  @override
  String get shareWithUsSubtitle => 'বন্ধুর সাথে শেয়ার করুন';

  @override
  String get rateApp => 'আযকার রেট করুন';

  @override
  String get rateAppSubtitle => 'সংক্ষিপ্ত রিভিউ দিন';

  @override
  String get previous => 'পূর্ববর্তী';

  @override
  String get next => 'পরবর্তী';

  @override
  String pageCounter(String current, String total) {
    return '$total এর মধ্যে $current';
  }

  @override
  String get done => 'সম্পন্ন ✓';

  @override
  String get addToFavorites => 'প্রিয় তালিকায় যোগ করুন';

  @override
  String get removeFromFavorites => 'প্রিয় তালিকা থেকে সরান';

  @override
  String get favorites => 'প্রিয়';

  @override
  String get allCategories => 'সব শ্রেণি';

  @override
  String get exitConfirmationTitle => 'এই সেশন থেকে বের হবেন?';

  @override
  String get exitConfirmationBody =>
      'আপনার অগ্রগতি হারিয়ে যাবে। আপনি কি নিশ্চিত?';

  @override
  String get cancel => 'বাতিল';

  @override
  String get exit => 'প্রস্থান';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get fontSize => 'ফন্টের আকার';

  @override
  String get sampleText => 'নমুনা লেখা';

  @override
  String get language => 'ভাষা';

  @override
  String get shareAppSubject => 'আযকার — সকাল ও সন্ধ্যার সহজ আযকার';

  @override
  String get shareAppBody =>
      '🤲 আযকার — সকাল ও সন্ধ্যার সহজ আযকার\n\nএকটি ফ্রি অ্যাপ যা হিসনুল মুসলিম থেকে প্রতিদিনের আযকার পড়তে সাহায্য করে।\n\n✨ বৈশিষ্ট্য:\n• সকাল ও সন্ধ্যার আযকার\n• ঘুম ও জাগরণের আযকার\n• ট্যাপ করে গণনা\n• অফলাইনে কাজ করে\n• সম্পূর্ণ ফ্রি, কোনো বিজ্ঞাপন নেই\n\nএখনই ডাউনলোড করুন:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'সেটিংস';

  @override
  String get settingsDisplay => 'ডিসপ্লে';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsTheme => 'ডার্ক মোড';

  @override
  String get searchHint => 'আযকার খুঁজুন';

  @override
  String get searchNoResults => 'কোনো ফলাফল নেই';

  @override
  String get audioPlay => 'তিলাওয়াত চালু করুন';

  @override
  String get audioStop => 'তিলাওয়াত বন্ধ করুন';

  @override
  String get audioDownloadFailed =>
      'অডিও লোড করা যায়নি। আপনার সংযোগ যাচাই করুন।';

  @override
  String get onboardingWelcome => 'আযকারে স্বাগতম';

  @override
  String get onboardingDescription =>
      'হিসনুল মুসলিম থেকে প্রতিদিনের আযকার, আপনার ভাষায়।';

  @override
  String get onboardingPickLanguage => 'আপনার ভাষা বেছে নিন';

  @override
  String get onboardingTapToCountTitle => 'গণনা করতে ট্যাপ করুন';

  @override
  String get onboardingTapToCountBody =>
      'জিকর কার্ডে ট্যাপ করে কাউন্টার বাড়ান। সম্পন্ন হলে স্বয়ংক্রিয়ভাবে পরবর্তীটিতে চলে যাবে।';

  @override
  String get onboardingSwipeTitle => 'চলাচলের জন্য বোতাম ব্যবহার করুন';

  @override
  String get onboardingSwipeBody =>
      'একই শ্রেণির জিকরগুলোর মধ্যে যেতে পূর্ববর্তী ও পরবর্তী চাপুন।';

  @override
  String get onboardingContinue => 'চালিয়ে যান';

  @override
  String get onboardingGetStarted => 'শুরু করুন';

  @override
  String get notificationMorningTitle => 'সকালের আযকারের সময়';

  @override
  String get notificationMorningBody =>
      'আযকার দিয়ে আপনার দিন শুরু করার জন্য কিছু সময়।';

  @override
  String get notificationEveningTitle => 'সন্ধ্যার আযকারের সময়';

  @override
  String get notificationEveningBody =>
      'আযকার দিয়ে আপনার সন্ধ্যা শুরু করার জন্য কিছু সময়।';

  @override
  String get notificationsScreenTitle => 'রিমাইন্ডার';

  @override
  String get notificationsScreenIntro =>
      'সকাল ও সন্ধ্যার আযকারের জন্য শান্ত রিমাইন্ডার।';

  @override
  String get notificationsMorningLabel => 'সকালের আযকার';

  @override
  String get notificationsEveningLabel => 'সন্ধ্যার আযকার';

  @override
  String get notificationsChannelName => 'আযকার রিমাইন্ডার';

  @override
  String get notificationsPermissionDenied =>
      'আপনার ডিভাইস সেটিংসে নোটিফিকেশন বন্ধ আছে।';

  @override
  String get notificationsPermissionDeniedAction => 'সেটিংস খুলুন';

  @override
  String get notificationsBatteryHelperTitle => 'নির্ভরযোগ্য ডেলিভারি';

  @override
  String get notificationsBatteryHelperBody =>
      'আযকারকে ব্যাকগ্রাউন্ডে চলতে দিন যেন রিমাইন্ডার সঠিক সময়ে আসে।';

  @override
  String get notificationsBatteryHelperAction =>
      'ব্যাকগ্রাউন্ড কার্যকলাপ অনুমোদন করুন';

  @override
  String get notificationsBatteryHelperOemHint =>
      'কিছু ফোনে (Xiaomi, Huawei, Samsung) রিমাইন্ডার মিস হলে ব্যাটারি সেভার সেটিংস দেখুন।';
}
