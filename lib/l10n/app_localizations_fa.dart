// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'حصن المسلم';

  @override
  String get shareWithUs => 'خیر را گسترش دهید';

  @override
  String get shareWithUsSubtitle => 'با یک دوست به اشتراک بگذارید';

  @override
  String get rateApp => 'به اذکار امتیاز دهید';

  @override
  String get rateAppSubtitle => 'نظر کوتاهی بنویسید';

  @override
  String get previous => 'قبلی';

  @override
  String get next => 'بعدی';

  @override
  String pageCounter(String current, String total) {
    return '$current از $total';
  }

  @override
  String get done => 'انجام شد ✓';

  @override
  String get addToFavorites => 'افزودن به علاقه‌مندی‌ها';

  @override
  String get removeFromFavorites => 'حذف از علاقه‌مندی‌ها';

  @override
  String get favorites => 'علاقه‌مندی‌ها';

  @override
  String get allCategories => 'همهٔ دسته‌ها';

  @override
  String get exitConfirmationTitle => 'از این بخش خارج می‌شوید؟';

  @override
  String get exitConfirmationBody =>
      'پیشرفت شما از دست خواهد رفت. آیا مطمئن هستید؟';

  @override
  String get cancel => 'انصراف';

  @override
  String get exit => 'خروج';

  @override
  String get ok => 'تأیید';

  @override
  String get fontSize => 'اندازهٔ متن';

  @override
  String get sampleText => 'نمونهٔ متن';

  @override
  String get language => 'زبان';

  @override
  String get shareAppSubject => 'اذکار — اذکار صبح و شام به‌سادگی';

  @override
  String get shareAppBody =>
      '🤲 اذکار — اذکار صبح و شام به‌سادگی\n\nبرنامه‌ای رایگان که در پایبندی به اذکار روزانه از کتاب حصن المسلم به شما کمک می‌کند.\n\n✨ ویژگی‌ها:\n• اذکار صبح و شام\n• اذکار خواب و بیداری\n• شمارش با یک لمس\n• کار بدون اینترنت\n• کاملاً رایگان و بدون تبلیغات\n\nهمین حالا دانلود کنید:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'تنظیمات';

  @override
  String get settingsDisplay => 'نمایش';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsTheme => 'حالت تیره';

  @override
  String get searchHint => 'جست‌وجوی اذکار';

  @override
  String get searchNoResults => 'نتیجه‌ای یافت نشد';

  @override
  String get audioPlay => 'پخش تلاوت';

  @override
  String get audioStop => 'توقف تلاوت';

  @override
  String get audioDownloadFailed =>
      'بارگذاری صدا ممکن نشد. اتصال خود را بررسی کنید.';

  @override
  String get onboardingWelcome => 'به اذکار خوش آمدید';

  @override
  String get onboardingDescription =>
      'اذکار روزانه از حصن المسلم، به زبان شما.';

  @override
  String get onboardingPickLanguage => 'زبان خود را انتخاب کنید';

  @override
  String get onboardingTapToCountTitle => 'برای شمارش لمس کنید';

  @override
  String get onboardingTapToCountBody =>
      'روی کارت ذکر بزنید تا شمارنده پیش برود. در پایان به‌طور خودکار به ذکر بعدی می‌رود.';

  @override
  String get onboardingSwipeTitle => 'از دکمه‌ها برای پیمایش استفاده کنید';

  @override
  String get onboardingSwipeBody =>
      'روی قبلی و بعدی بزنید تا میان اذکار یک دسته جابه‌جا شوید.';

  @override
  String get onboardingContinue => 'ادامه';

  @override
  String get onboardingGetStarted => 'شروع';

  @override
  String get notificationMorningTitle => 'وقت اذکار صبح است';

  @override
  String get notificationMorningBody => 'لحظه‌ای آرام برای آغاز روز با اذکار.';

  @override
  String get notificationEveningTitle => 'وقت اذکار شام است';

  @override
  String get notificationEveningBody => 'لحظه‌ای آرام برای آغاز شام با اذکار.';

  @override
  String get notificationsScreenTitle => 'یادآورها';

  @override
  String get notificationsScreenIntro => 'یادآورهای آرام برای اذکار صبح و شام.';

  @override
  String get notificationsMorningLabel => 'اذکار صبح';

  @override
  String get notificationsEveningLabel => 'اذکار شام';

  @override
  String get notificationsChannelName => 'یادآورهای اذکار';

  @override
  String get notificationsPermissionDenied =>
      'اعلان‌ها در تنظیمات دستگاه شما غیرفعال هستند.';

  @override
  String get notificationsPermissionDeniedAction => 'باز کردن تنظیمات';

  @override
  String get notificationsBatteryHelperTitle => 'تحویل مطمئن';

  @override
  String get notificationsBatteryHelperBody =>
      'به اذکار اجازه دهید در پس‌زمینه اجرا شود تا یادآورها به موقع برسند.';

  @override
  String get notificationsBatteryHelperAction => 'اجازهٔ فعالیت در پس‌زمینه';

  @override
  String get notificationsBatteryHelperOemHint =>
      'در بعضی گوشی‌ها (شیائومی، هوآوی، سامسونگ) اگر یادآورها نرسیدند تنظیمات صرفه‌جویی باتری را بررسی کنید.';
}
