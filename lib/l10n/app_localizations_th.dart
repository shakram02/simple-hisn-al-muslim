// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ฮิสนุล มุสลิม';

  @override
  String get shareWithUs => 'ส่งต่อความดี';

  @override
  String get shareWithUsSubtitle => 'แชร์กับเพื่อน';

  @override
  String get rateApp => 'ให้คะแนนอัซการ์';

  @override
  String get rateAppSubtitle => 'เขียนรีวิวสั้น ๆ';

  @override
  String get previous => 'ก่อนหน้า';

  @override
  String get next => 'ถัดไป';

  @override
  String pageCounter(String current, String total) {
    return '$current จาก $total';
  }

  @override
  String get done => 'เสร็จแล้ว ✓';

  @override
  String get addToFavorites => 'เพิ่มในรายการโปรด';

  @override
  String get removeFromFavorites => 'ลบจากรายการโปรด';

  @override
  String get favorites => 'รายการโปรด';

  @override
  String get allCategories => 'ทุกหมวดหมู่';

  @override
  String get exitConfirmationTitle => 'ออกจากการอ่านหรือไม่?';

  @override
  String get exitConfirmationBody =>
      'ความคืบหน้าของคุณจะหายไป คุณแน่ใจหรือไม่?';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get exit => 'ออก';

  @override
  String get ok => 'ตกลง';

  @override
  String get fontSize => 'ขนาดตัวอักษร';

  @override
  String get sampleText => 'ข้อความตัวอย่าง';

  @override
  String get language => 'ภาษา';

  @override
  String get shareAppSubject => 'อัซการ์ — อัซการ์เช้า-เย็นที่ใช้งานง่าย';

  @override
  String get shareAppBody =>
      '🤲 อัซการ์ — อัซการ์เช้า-เย็นที่ใช้งานง่าย\n\nแอปฟรีที่ช่วยให้คุณรักษาการอ่านอัซการ์ประจำวันจากหนังสือฮิศนุลมุสลิม\n\n✨ คุณสมบัติ:\n• อัซการ์เช้าและเย็น\n• อัซการ์ก่อนนอนและตื่นนอน\n• แตะเพื่อ้นับ\n• ใช้งานแบบออฟไลน์ได้\n• ฟรีโดยสมบูรณ์ ไม่มีโฆษณา\n\nดาวน์โหลดเลย:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get settingsDisplay => 'การแสดงผล';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsTheme => 'โหมดมืด';

  @override
  String get searchHint => 'ค้นหาอัซการ์';

  @override
  String get searchNoResults => 'ไม่พบผลลัพธ์';

  @override
  String get audioPlay => 'เล่นเสียงอ่าน';

  @override
  String get audioStop => 'หยุดเสียงอ่าน';

  @override
  String get audioDownloadFailed =>
      'ไม่สามารถโหลดเสียงได้ ตรวจสอบการเชื่อมต่อของคุณ';

  @override
  String get onboardingWelcome => 'ยินดีต้อนรับสู่อัซการ์';

  @override
  String get onboardingDescription =>
      'อัซการ์ประจำวันจากฮิศนุลมุสลิม ในภาษาของคุณ';

  @override
  String get onboardingPickLanguage => 'เลือกภาษาของคุณ';

  @override
  String get onboardingTapToCountTitle => 'แตะเพื่อนับ';

  @override
  String get onboardingTapToCountBody =>
      'แตะการ์ดซิกร์เพื่อเพิ่มตัวนับ จะเลื่อนไปยังซิกร์ถัดไปโดยอัตโนมัติเมื่อครบ';

  @override
  String get onboardingSwipeTitle => 'ใช้ปุ่มเพื่อเลื่อนดู';

  @override
  String get onboardingSwipeBody =>
      'แตะ ก่อนหน้า และ ถัดไป เพื่อเปลี่ยนระหว่างซิกร์ในหมวดหมู่';

  @override
  String get onboardingContinue => 'ต่อไป';

  @override
  String get onboardingGetStarted => 'เริ่มต้น';

  @override
  String get notificationMorningTitle => 'ถึงเวลาอัซการ์เช้า';

  @override
  String get notificationMorningBody =>
      'ช่วงเวลาเงียบสงบเพื่อเริ่มต้นวันด้วยอัซการ์';

  @override
  String get notificationEveningTitle => 'ถึงเวลาอัซการ์เย็น';

  @override
  String get notificationEveningBody =>
      'ช่วงเวลาเงียบสงบเพื่อเริ่มต้นค่ำคืนด้วยอัซการ์';

  @override
  String get notificationsScreenTitle => 'การแจ้งเตือน';

  @override
  String get notificationsScreenIntro =>
      'การแจ้งเตือนที่เงียบสำหรับอัซการ์เช้าและเย็น';

  @override
  String get notificationsMorningLabel => 'อัซการ์เช้า';

  @override
  String get notificationsEveningLabel => 'อัซการ์เย็น';

  @override
  String get notificationsChannelName => 'การแจ้งเตือนอัซการ์';

  @override
  String get notificationsPermissionDenied =>
      'การแจ้งเตือนถูกปิดอยู่ในการตั้งค่าอุปกรณ์ของคุณ';

  @override
  String get notificationsPermissionDeniedAction => 'เปิดการตั้งค่า';

  @override
  String get notificationsBatteryHelperTitle => 'การส่งที่เชื่อถือได้';

  @override
  String get notificationsBatteryHelperBody =>
      'อนุญาตให้ Azkar ทำงานเบื้องหลังเพื่อให้การแจ้งเตือนมาตรงเวลา';

  @override
  String get notificationsBatteryHelperAction => 'อนุญาตกิจกรรมเบื้องหลัง';

  @override
  String get notificationsBatteryHelperOemHint =>
      'บางรุ่น (Xiaomi, Huawei, Samsung) ให้ตรวจสอบการตั้งค่าประหยัดแบตเตอรี่หากการแจ้งเตือนยังขาดหาย';
}
