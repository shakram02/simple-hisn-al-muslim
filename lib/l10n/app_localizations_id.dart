// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Sebarkan kebaikan';

  @override
  String get shareWithUsSubtitle => 'Bagikan dengan teman';

  @override
  String get rateApp => 'Beri rating Azkar';

  @override
  String get rateAppSubtitle => 'Tulis ulasan singkat';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get next => 'Berikutnya';

  @override
  String pageCounter(String current, String total) {
    return '$current dari $total';
  }

  @override
  String get done => 'Selesai ✓';

  @override
  String get addToFavorites => 'Tambahkan ke favorit';

  @override
  String get removeFromFavorites => 'Hapus dari favorit';

  @override
  String get favorites => 'Favorit';

  @override
  String get allCategories => 'Semua kategori';

  @override
  String get exitConfirmationTitle => 'Keluar dari sesi?';

  @override
  String get exitConfirmationBody =>
      'Kemajuan Anda akan hilang. Apakah Anda yakin ingin keluar?';

  @override
  String get cancel => 'Batal';

  @override
  String get exit => 'Keluar';

  @override
  String get ok => 'OK';

  @override
  String get fontSize => 'Ukuran font';

  @override
  String get sampleText => 'Contoh teks';

  @override
  String get language => 'Bahasa';

  @override
  String get shareAppSubject => 'Azkar — Adhkar pagi & malam yang mudah';

  @override
  String get shareAppBody =>
      '🤲 Azkar — Adhkar pagi & malam yang mudah\n\nAplikasi gratis untuk membantu Anda menjaga zikir harian dari Hisnul Muslim.\n\n✨ Fitur:\n• Zikir pagi & petang\n• Zikir tidur & bangun\n• Penghitung sentuhan\n• Bekerja secara offline\n• Sepenuhnya gratis, tanpa iklan\n\nUnduh sekarang:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Pengaturan';

  @override
  String get settingsDisplay => 'Tampilan';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsTheme => 'Mode gelap';

  @override
  String get searchHint => 'Cari adhkar';

  @override
  String get searchNoResults => 'Tidak ada hasil';

  @override
  String get audioPlay => 'Putar bacaan';

  @override
  String get audioStop => 'Hentikan bacaan';

  @override
  String get audioDownloadFailed =>
      'Tidak dapat memuat audio. Periksa koneksi Anda.';

  @override
  String get onboardingWelcome => 'Selamat datang di Azkar';

  @override
  String get onboardingDescription =>
      'Zikir harian dari Hisnul Muslim, dalam bahasa Anda.';

  @override
  String get onboardingPickLanguage => 'Pilih bahasa Anda';

  @override
  String get onboardingTapToCountTitle => 'Ketuk untuk menghitung';

  @override
  String get onboardingTapToCountBody =>
      'Ketuk kartu zikir untuk menambah penghitung. Akan otomatis berpindah ke zikir berikutnya saat selesai.';

  @override
  String get onboardingSwipeTitle => 'Gunakan tombol untuk navigasi';

  @override
  String get onboardingSwipeBody =>
      'Ketuk Sebelumnya dan Berikutnya untuk berpindah antar zikir dalam kategori.';

  @override
  String get onboardingContinue => 'Lanjutkan';

  @override
  String get onboardingGetStarted => 'Mulai';

  @override
  String get notificationMorningTitle => 'Saatnya zikir pagi';

  @override
  String get notificationMorningBody =>
      'Sejenak untuk memulai hari dengan zikir.';

  @override
  String get notificationEveningTitle => 'Saatnya zikir petang';

  @override
  String get notificationEveningBody =>
      'Sejenak untuk memulai petang dengan zikir.';

  @override
  String get notificationsScreenTitle => 'Pengingat';

  @override
  String get notificationsScreenIntro =>
      'Pengingat ringan untuk zikir pagi dan petang.';

  @override
  String get notificationsMorningLabel => 'Zikir pagi';

  @override
  String get notificationsEveningLabel => 'Zikir petang';

  @override
  String get notificationsChannelName => 'Pengingat Azkar';

  @override
  String get notificationsPermissionDenied =>
      'Notifikasi dimatikan di pengaturan perangkat Anda.';

  @override
  String get notificationsPermissionDeniedAction => 'Buka pengaturan';

  @override
  String get notificationsBatteryHelperTitle => 'Pengiriman andal';

  @override
  String get notificationsBatteryHelperBody =>
      'Izinkan Azkar berjalan di latar belakang agar pengingat muncul tepat waktu.';

  @override
  String get notificationsBatteryHelperAction =>
      'Izinkan aktivitas latar belakang';

  @override
  String get notificationsBatteryHelperOemHint =>
      'Pada beberapa ponsel (Xiaomi, Huawei, Samsung), periksa pengaturan hemat baterai jika pengingat masih terlewat.';
}
