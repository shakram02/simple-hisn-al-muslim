// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حصن المسلم';

  @override
  String get shareWithUs => 'شاركنا الأجر';

  @override
  String get shareWithUsSubtitle => 'شارك مع صديق';

  @override
  String get rateApp => 'قيّم أذكار';

  @override
  String get rateAppSubtitle => 'اترك تقييمًا قصيرًا';

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String pageCounter(String current, String total) {
    return '$current من $total';
  }

  @override
  String get done => 'تم ✓';

  @override
  String get addToFavorites => 'إضافة للمفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get allCategories => 'كل الأذكار';

  @override
  String get exitConfirmationTitle => 'تأكيد الخروج';

  @override
  String get exitConfirmationBody => 'سيتم فقدان تقدمك. هل تريد الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get exit => 'خروج';

  @override
  String get ok => 'موافق';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get sampleText => 'مثال للنص';

  @override
  String get language => 'اللغة';

  @override
  String get shareAppSubject => 'تطبيق أذكار الصباح والمساء الميسرة';

  @override
  String get shareAppBody =>
      '🤲 أذكار الصباح والمساء الميسرة\n\nتطبيق مجاني يساعدك على المحافظة على الأذكار اليومية من كتاب حصن المسلم\n\n✨ مميزات التطبيق:\n• أذكار الصباح والمساء\n• أذكار النوم والاستيقاظ\n• عداد للأذكار\n• يعمل بدون إنترنت\n• مجاني تماماً وبدون إعلانات\n\nحمل التطبيق الآن:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsDisplay => 'العرض';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'الوضع الداكن';

  @override
  String get searchHint => 'ابحث في الأذكار';

  @override
  String get searchNoResults => 'لا توجد نتائج';

  @override
  String get audioPlay => 'تشغيل التلاوة';

  @override
  String get audioStop => 'إيقاف التلاوة';

  @override
  String get audioDownloadFailed =>
      'تعذّر تحميل الصوت. تأكد من اتصالك بالإنترنت.';

  @override
  String get onboardingWelcome => 'مرحبًا بك في أذكار';

  @override
  String get onboardingDescription => 'أذكار يومية من حصن المسلم، بلغتك.';

  @override
  String get onboardingPickLanguage => 'اختر لغتك';

  @override
  String get onboardingTapToCountTitle => 'اضغط للعدّ';

  @override
  String get onboardingTapToCountBody =>
      'اضغط على بطاقة الذكر لزيادة العدّاد. سينتقل تلقائيًا إلى الذكر التالي عند الإكمال.';

  @override
  String get onboardingSwipeTitle => 'تنقّل عبر الأزرار';

  @override
  String get onboardingSwipeBody =>
      'اضغط السابق والتالي للتنقّل بين أذكار الفئة.';

  @override
  String get onboardingContinue => 'متابعة';

  @override
  String get onboardingGetStarted => 'ابدأ';

  @override
  String get notificationMorningTitle => 'حان وقت أذكار الصباح';

  @override
  String get notificationMorningBody => 'دقائق قليلة لتبدأ بها يومك بالأذكار.';

  @override
  String get notificationEveningTitle => 'حان وقت أذكار المساء';

  @override
  String get notificationEveningBody => 'دقائق قليلة لتبدأ بها مساءك بالأذكار.';

  @override
  String get notificationsScreenTitle => 'التذكيرات';

  @override
  String get notificationsScreenIntro => 'تذكيرات هادئة بأذكار الصباح والمساء.';

  @override
  String get notificationsMorningLabel => 'أذكار الصباح';

  @override
  String get notificationsEveningLabel => 'أذكار المساء';

  @override
  String get notificationsChannelName => 'تذكيرات الأذكار';

  @override
  String get notificationsPermissionDenied =>
      'الإشعارات معطّلة في إعدادات جهازك.';

  @override
  String get notificationsPermissionDeniedAction => 'فتح الإعدادات';

  @override
  String get notificationsBatteryHelperTitle => 'تشغيل موثوق';

  @override
  String get notificationsBatteryHelperBody =>
      'اسمح لتطبيق أذكار بالعمل في الخلفية حتى تصل التذكيرات في وقتها.';

  @override
  String get notificationsBatteryHelperAction => 'السماح بالعمل في الخلفية';

  @override
  String get notificationsBatteryHelperOemHint =>
      'في بعض الأجهزة (شاومي وهواوي وسامسونج) راجع إعدادات توفير البطارية إذا لم تصل التذكيرات.';
}
