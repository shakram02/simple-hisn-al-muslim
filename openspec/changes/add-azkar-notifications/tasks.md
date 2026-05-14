# Tasks

## 1. Dependency & Platform Setup

### 1.1 Common
- [x] 1.1.1 Add `flutter_local_notifications` to `pubspec.yaml`; pin to a specific minor (e.g. `^17.2.0`). Run `flutter pub get`.
- [x] 1.1.2 Add `permission_handler` to `pubspec.yaml` (used only for the Android battery-optimization permission flow).
- [x] 1.1.3 Confirm `timezone` is transitively included (the notifications package pulls it in); we'll use `tz.TZDateTime` for zoned schedules.

### 1.2 Android
- [x] 1.2.1 In `android/app/src/main/AndroidManifest.xml`, declare:
  - `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>`
  - `<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>`
  - `<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"/>`
- [x] 1.2.2 Register the package's `ScheduledNotificationBootReceiver` + `ScheduledNotificationReceiver` per the package's Android setup docs.
- [x] 1.2.3 Verify `compileSdk` ≥ 33 in `android/app/build.gradle` (needed for the runtime-permission API).

### 1.3 iOS
- [x] 1.3.1 In `ios/Runner/AppDelegate.swift`, register the plugin's callback (`FlutterLocalNotificationsPlugin.setPluginRegistrantCallback`) per the package's iOS setup docs.
- [x] 1.3.2 No `Info.plist` permission strings required for the basic alert+badge flow (system handles the prompt).
- [x] 1.3.3 Confirm iOS deployment target meets the package's minimum (iOS 12+).

## 2. Scheduler Module
- [x] 2.1 Create `lib/notifications/scheduler.dart` with a `NotificationScheduler` singleton (lazy init).
- [x] 2.2 Implement `init()`:
  - Initialize `FlutterLocalNotificationsPlugin` with `AndroidInitializationSettings` + `DarwinInitializationSettings`.
  - Configure the Android channel `azkar_reminder` (importance `default`, no sound, no vibration, localized name "Azkar reminders").
  - Register the tap handler (`onDidReceiveNotificationResponse`) that decodes the payload.
- [x] 2.3 Implement `requestPermission()`:
  - Android: `requestNotificationsPermission()` on the Android-specific plugin.
  - iOS: `requestPermissions(alert: true, badge: true, sound: false)` on the iOS plugin.
  - Returns `bool` (granted).
- [x] 2.4 Implement `areNotificationsEnabled()`:
  - Android: package's `areNotificationsEnabled()`.
  - iOS: check via `checkPermissions()` → all granted == enabled.
- [x] 2.5 Implement `scheduleMorning(TimeOfDay)` and `scheduleEvening(TimeOfDay)`:
  - Compute next occurrence in local TZ (today if time still ahead, else tomorrow).
  - Call `zonedSchedule` with `matchDateTimeComponents: DateTimeComponents.time` for daily repeat.
  - Fixed notification ID per reminder (1001 morning, 1002 evening).
  - Title from `AppLocalizations` (`notificationMorningTitle` / `notificationEveningTitle`); body empty.
  - Payload: `"27"` (category id for tap navigation).
  - Android details: `androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle`, `importance: Importance.defaultImportance`, `playSound: false`, `enableVibration: false`.
  - iOS details: `DarwinNotificationDetails(presentSound: false, presentBadge: true, presentAlert: true, interruptionLevel: InterruptionLevel.passive)`.
- [x] 2.6 Implement `cancelMorning()` and `cancelEvening()` calling `cancel(id)`.
- [x] 2.7 Implement `reapplyFromPreferences()`: reads the four prefs, calls schedule/cancel accordingly. Used at app boot.
- [x] 2.8 Hook the tap callback through to a global `ValueNotifier<int?>` (`pendingTapCategoryId`) consumed by `main.dart` to perform the deep-link navigation.
- [x] 2.9 Add `isBatteryOptimizationIgnored()`:
  - Android: `Permission.ignoreBatteryOptimizations.status.isGranted`.
  - iOS / other: always `true` (no-op — no equivalent concept).
- [x] 2.10 Add `requestIgnoreBatteryOptimization()`:
  - Android: `Permission.ignoreBatteryOptimizations.request()`. Returns the `PermissionStatus` so the UI knows whether to keep showing the card.
  - iOS: no-op, returns `granted`.

## 3. Preferences
- [x] 3.1 Extend `lib/ui/settings/settings_pref.dart` (or new `lib/notifications/preferences.dart` if helpers grow) with:
  - `getMorningEnabled()` / `saveMorningEnabled(bool)`
  - `getMorningTime()` / `saveMorningTime(TimeOfDay)` — store as `"HH:MM"` string
  - `getEveningEnabled()` / `saveEveningEnabled(bool)`
  - `getEveningTime()` / `saveEveningTime(TimeOfDay)`
- [x] 3.2 Defaults: `morningEnabled=false`, `morningTime=06:00`, `eveningEnabled=false`, `eveningTime=17:00`.
- [ ] 3.3 Unit-test the `TimeOfDay` ↔ string roundtrip (deferred — implementation is trivial round-trip; test recommended before next release).

## 4. Notifications Settings Screen
- [x] 4.1 Create `lib/ui/notifications/screen.dart` exporting `NotificationsScreen`.
- [x] 4.2 Layout: `Scaffold` with `ZikrAppBar`, body is a `ListView` containing two `_ReminderRow` widgets (morning, evening) styled to match the polish-pass vocabulary (cream surface, no borders, soft shadow on the time-picker row).
- [x] 4.3 Each `_ReminderRow`: title text, subtitle showing the chosen time when enabled, trailing `Switch`, tap-anywhere-on-the-time opens `showTimePicker`.
- [x] 4.4 Top of the screen: a one-line intro + the inline "permission revoked" message (rendered conditionally via `FutureBuilder` on `areNotificationsEnabled()`).
- [x] 4.5 Wire toggles to call scheduler + persist via preferences. Wire time picker to reschedule on change.
- [x] 4.6 Permission flow: when user toggles ON for the first time, await `requestPermission()`. If denied, snap toggle back, show inline message.
- [x] 4.7 **Battery-optimization helper card** (Android only):
  - Render conditionally when `(morningEnabled || eveningEnabled) AND !isBatteryOptimizationIgnored() AND platform == Android`.
  - Card has: primary title (`notificationsBatteryHelperTitle`), short body (`notificationsBatteryHelperBody`), primary button (`notificationsBatteryHelperAction` → calls `requestIgnoreBatteryOptimization()`), small footer hint (`notificationsBatteryHelperOemHint`) about OEM-specific killers.
  - Card hides automatically once permission is granted (the `FutureBuilder`/`StateNotifier` re-evaluates on `setState`).
  - Card stays visible if denied — no nag dialog, just persistent visibility on every visit until granted.
  - On iOS the card never renders.

## 5. Drawer Integration
- [x] 5.1 In `lib/ui/drawer/menu.dart`, add a "Notifications" `ListTile` below the existing "Language" tile. Icon: `Icons.notifications_outlined`. On tap, push `NotificationsScreen`.

## 6. App-Boot & Tap-Handling Wiring
- [x] 6.1 In `lib/main.dart`'s `_initializeApp()`, call `NotificationScheduler.instance.init()` AND `reapplyFromPreferences()` (after SharedPreferences are loaded).
- [x] 6.2 In `_buildHome()`, listen to `pendingTapCategoryId`; on non-null value, push the matching `ZikrCategoryDetailScreen` (loading the category by id from the repo), then clear the notifier.
- [x] 6.3 Handle the "app was launched FROM the notification" case via `flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails()` during init.

## 7. Localization

### 7.1 New ARB keys
- [x] 7.1.1 Add the following keys to `app_en.arb` (template):
  - `notificationMorningTitle` — "Time for morning azkar"
  - `notificationEveningTitle` — "Time for evening azkar"
  - `notificationsScreenTitle` — "Notifications"
  - `notificationsScreenIntro` — "Quiet daily reminders for morning and evening azkar."
  - `notificationsMorningLabel` — "Morning azkar"
  - `notificationsEveningLabel` — "Evening azkar"
  - `notificationsChannelName` — "Azkar reminders"
  - `notificationsPermissionDenied` — "Notifications are disabled in your device settings."
  - `notificationsPermissionDeniedAction` — "Open settings"
  - `notificationsBatteryHelperTitle` — "Reliable delivery"
  - `notificationsBatteryHelperBody` — "Let Azkar run in the background so reminders fire on time."
  - `notificationsBatteryHelperAction` — "Allow background activity"
  - `notificationsBatteryHelperOemHint` — "On some phones (Xiaomi, Huawei, Samsung), check your battery-saver settings if reminders still miss."

### 7.2 Native-speaker-reviewed translations (apply to each `app_<locale>.arb`)

These were reviewed before approval; use exactly these strings.

**`ar` (Arabic)**
- morning: `حان وقت أذكار الصباح`
- evening: `حان وقت أذكار المساء`
- channel: `تذكيرات الأذكار`
- intro: `تذكيرات هادئة بأذكار الصباح والمساء.`
- screen title: `التذكيرات`
- morning label: `أذكار الصباح`
- evening label: `أذكار المساء`
- permission denied: `الإشعارات معطّلة في إعدادات جهازك.`
- permission action: `فتح الإعدادات`

**`id` (Indonesian)**
- morning: `Saatnya zikir pagi`
- evening: `Saatnya zikir petang`
- channel: `Pengingat Azkar`
- intro: `Pengingat ringan untuk zikir pagi dan petang.`
- screen title: `Pengingat`
- morning label: `Zikir pagi`
- evening label: `Zikir petang`
- permission denied: `Notifikasi dimatikan di pengaturan perangkat Anda.`
- permission action: `Buka pengaturan`

**`bn` (Bengali)**
- morning: `সকালের আযকারের সময়`
- evening: `সন্ধ্যার আযকারের সময়`
- channel: `আযকার রিমাইন্ডার`
- intro: `সকাল ও সন্ধ্যার আযকারের জন্য শান্ত রিমাইন্ডার।`
- screen title: `রিমাইন্ডার`
- morning label: `সকালের আযকার`
- evening label: `সন্ধ্যার আযকার`
- permission denied: `আপনার ডিভাইস সেটিংসে নোটিফিকেশন বন্ধ আছে।`
- permission action: `সেটিংস খুলুন`

**`bs` (Bosnian)**
- morning: `Vrijeme je za jutarnje zikrove`
- evening: `Vrijeme je za večernje zikrove`
- channel: `Podsjetnici za zikrove`
- intro: `Tihi dnevni podsjetnici za jutarnje i večernje zikrove.`
- screen title: `Podsjetnici`
- morning label: `Jutarnji zikrovi`
- evening label: `Večernji zikrovi`
- permission denied: `Obavještenja su isključena u postavkama uređaja.`
- permission action: `Otvori postavke`

**`es` (Spanish)**
- morning: `Es hora de los adhkar de la mañana`
- evening: `Es hora de los adhkar de la tarde`
- channel: `Recordatorios de adhkar`
- intro: `Recordatorios discretos para los adhkar de la mañana y la tarde.`
- screen title: `Recordatorios`
- morning label: `Adhkar de la mañana`
- evening label: `Adhkar de la tarde`
- permission denied: `Las notificaciones están desactivadas en los ajustes de tu dispositivo.`
- permission action: `Abrir ajustes`

**`fa` (Persian)**
- morning: `وقت اذکار صبح است`
- evening: `وقت اذکار شام است`
- channel: `یادآورهای اذکار`
- intro: `یادآورهای آرام برای اذکار صبح و شام.`
- screen title: `یادآورها`
- morning label: `اذکار صبح`
- evening label: `اذکار شام`
- permission denied: `اعلان‌ها در تنظیمات دستگاه شما غیرفعال هستند.`
- permission action: `باز کردن تنظیمات`

**`ha` (Hausa)**
- morning: `Lokacin azkar safe`
- evening: `Lokacin azkar yamma`
- channel: `Tunatarwa na Azkar`
- intro: `Tunatarwa shiru don azkar safe da yamma.`
- screen title: `Tunatarwa`
- morning label: `Azkar safe`
- evening label: `Azkar yamma`
- permission denied: `An kashe sanarwar a saitunan na'urarka.`
- permission action: `Buɗe saitunan`

**`hi` (Hindi)**
- morning: `सुबह के अज़कार का समय हो गया`
- evening: `शाम के अज़कार का समय हो गया`
- channel: `अज़कार रिमाइंडर`
- intro: `सुबह और शाम के अज़कार के लिए शांत रिमाइंडर।`
- screen title: `रिमाइंडर`
- morning label: `सुबह के अज़कार`
- evening label: `शाम के अज़कार`
- permission denied: `आपके डिवाइस की सेटिंग्स में नोटिफिकेशन बंद हैं।`
- permission action: `सेटिंग्स खोलें`

**`pt` (Portuguese)**
- morning: `É hora dos adhkar da manhã`
- evening: `É hora dos adhkar da tarde`
- channel: `Lembretes de adhkar`
- intro: `Lembretes discretos para os adhkar da manhã e da tarde.`
- screen title: `Lembretes`
- morning label: `Adhkar da manhã`
- evening label: `Adhkar da tarde`
- permission denied: `As notificações estão desativadas nas configurações do seu dispositivo.`
- permission action: `Abrir configurações`

**`so` (Somali)**
- morning: `Waa wakhtigii adhkaarta subaxa`
- evening: `Waa wakhtigii adhkaarta galabta`
- channel: `Xasuusinta Adhkaarta`
- intro: `Xasuusin aamusan oo adhkaarta subaxa iyo galabta.`
- screen title: `Xasuusinta`
- morning label: `Adhkaarta subaxa`
- evening label: `Adhkaarta galabta`
- permission denied: `Ogeysiisyada waxaa laga damiyay dejinta aaladdaada.`
- permission action: `Fur dejinta`

**`sw` (Swahili)**
- morning: `Muda wa adhkar za asubuhi`
- evening: `Muda wa adhkar za jioni`
- channel: `Vikumbusho vya Adhkar`
- intro: `Vikumbusho vya kimya kwa adhkar za asubuhi na jioni.`
- screen title: `Vikumbusho`
- morning label: `Adhkar za asubuhi`
- evening label: `Adhkar za jioni`
- permission denied: `Arifa zimezimwa katika mipangilio ya kifaa chako.`
- permission action: `Fungua mipangilio`

**`th` (Thai)**
- morning: `ถึงเวลาอัซการ์เช้า`
- evening: `ถึงเวลาอัซการ์เย็น`
- channel: `การแจ้งเตือนอัซการ์`
- intro: `การแจ้งเตือนที่เงียบสำหรับอัซการ์เช้าและเย็น`
- screen title: `การแจ้งเตือน`
- morning label: `อัซการ์เช้า`
- evening label: `อัซการ์เย็น`
- permission denied: `การแจ้งเตือนถูกปิดอยู่ในการตั้งค่าอุปกรณ์ของคุณ`
- permission action: `เปิดการตั้งค่า`

**`yo` (Yoruba)**
- morning: `Akoko fun adhkar owurọ`
- evening: `Akoko fun adhkar irọlẹ`
- channel: `Iranti Adhkar`
- intro: `Awọn iranti aladun fun adhkar owurọ ati irọlẹ.`
- screen title: `Iranti`
- morning label: `Adhkar owurọ`
- evening label: `Adhkar irọlẹ`
- permission denied: `A ti pa awọn ifitonileti ninu eto ẹrọ rẹ.`
- permission action: `Ṣii eto`

**`zh` (Chinese)**
- morning: `晨间念词时间到了`
- evening: `晚间念词时间到了`
- channel: `Azkar 提醒`
- intro: `晨晚念词的安静提醒。`
- screen title: `提醒`
- morning label: `晨间念词`
- evening label: `晚间念词`
- permission denied: `通知已在设备设置中关闭。`
- permission action: `打开设置`

### 7.2.16 Battery-optimization helper strings (Android only — native-speaker-reviewed)

For each locale, add the four battery-helper keys. The OEM hint is intentionally concise across locales.

| Locale | helperTitle | helperBody | helperAction | helperOemHint |
|---|---|---|---|---|
| ar | `تشغيل موثوق` | `اسمح لتطبيق أذكار بالعمل في الخلفية حتى تصل التذكيرات في وقتها.` | `السماح بالعمل في الخلفية` | `في بعض الأجهزة (شاومي وهواوي وسامسونج) راجع إعدادات توفير البطارية إذا لم تصل التذكيرات.` |
| en | `Reliable delivery` | `Let Azkar run in the background so reminders fire on time.` | `Allow background activity` | `On some phones (Xiaomi, Huawei, Samsung), check your battery-saver settings if reminders still miss.` |
| id | `Pengiriman andal` | `Izinkan Azkar berjalan di latar belakang agar pengingat muncul tepat waktu.` | `Izinkan aktivitas latar belakang` | `Pada beberapa ponsel (Xiaomi, Huawei, Samsung), periksa pengaturan hemat baterai jika pengingat masih terlewat.` |
| bn | `নির্ভরযোগ্য ডেলিভারি` | `আযকারকে ব্যাকগ্রাউন্ডে চলতে দিন যেন রিমাইন্ডার সঠিক সময়ে আসে।` | `ব্যাকগ্রাউন্ড কার্যকলাপ অনুমোদন করুন` | `কিছু ফোনে (Xiaomi, Huawei, Samsung) রিমাইন্ডার মিস হলে ব্যাটারি সেভার সেটিংস দেখুন।` |
| bs | `Pouzdana isporuka` | `Dozvolite Azkaru da radi u pozadini kako bi podsjetnici stizali na vrijeme.` | `Dozvoli pozadinsku aktivnost` | `Na nekim telefonima (Xiaomi, Huawei, Samsung), provjerite postavke uštede baterije ako podsjetnici i dalje ne stižu.` |
| es | `Entrega fiable` | `Permite que Azkar funcione en segundo plano para que los recordatorios lleguen a tiempo.` | `Permitir actividad en segundo plano` | `En algunos teléfonos (Xiaomi, Huawei, Samsung), revisa los ajustes de ahorro de batería si los recordatorios fallan.` |
| fa | `تحویل مطمئن` | `به اذکار اجازه دهید در پس‌زمینه اجرا شود تا یادآورها به موقع برسند.` | `اجازهٔ فعالیت در پس‌زمینه` | `در بعضی گوشی‌ها (شیائومی، هوآوی، سامسونگ) اگر یادآورها نرسیدند تنظیمات صرفه‌جویی باتری را بررسی کنید.` |
| ha | `Aiko abin dogara` | `Bari Azkar ya ci gaba a baya don tunatarwa ta kasance a kan lokaci.` | `Yarda da ayyukan baya` | `A wasu wayoyi (Xiaomi, Huawei, Samsung), duba saitunan ceton batir idan har yanzu tunatarwa ba ta zo ba.` |
| hi | `विश्वसनीय डिलीवरी` | `अज़कार को बैकग्राउंड में चलने दें ताकि रिमाइंडर समय पर आएं।` | `बैकग्राउंड गतिविधि की अनुमति दें` | `कुछ फ़ोन (Xiaomi, Huawei, Samsung) में रिमाइंडर मिस होने पर बैटरी सेवर सेटिंग्स देखें।` |
| pt | `Entrega confiável` | `Permita que o Azkar seja executado em segundo plano para os lembretes chegarem na hora.` | `Permitir atividade em segundo plano` | `Em alguns celulares (Xiaomi, Huawei, Samsung), verifique as configurações de economia de bateria se os lembretes ainda falharem.` |
| so | `Soo gaarsiin lagu kalsoon yahay` | `U ogolow Azkar inay ka shaqayso gadaal si xasuusinta ay waqtigeeda u soo gaarto.` | `U ogolow shaqada gadaasha` | `Qaar ka mid ah taleefannada (Xiaomi, Huawei, Samsung), eeg dejinta keydinta batariga haddii xasuusinta weli aysan iman.` |
| sw | `Utoaji wa kuaminika` | `Ruhusu Azkar kuendesha chinichini ili vikumbusho vifike kwa wakati.` | `Ruhusu shughuli za chinichini` | `Kwenye simu fulani (Xiaomi, Huawei, Samsung), angalia mipangilio ya kuhifadhi betri ikiwa vikumbusho bado havifiki.` |
| th | `การส่งที่เชื่อถือได้` | `อนุญาตให้ Azkar ทำงานเบื้องหลังเพื่อให้การแจ้งเตือนมาตรงเวลา` | `อนุญาตกิจกรรมเบื้องหลัง` | `บางรุ่น (Xiaomi, Huawei, Samsung) ให้ตรวจสอบการตั้งค่าประหยัดแบตเตอรี่หากการแจ้งเตือนยังขาดหาย` |
| yo | `Ifijiṣẹ tó gbẹkẹlé` | `Jẹ́ kí Azkar ṣiṣẹ́ ní ẹhin ki awọn iranti baà dé ni akoko.` | `Faye gba iṣẹ ẹhin` | `Ní àwọn fóònù kan (Xiaomi, Huawei, Samsung), ṣàyẹ̀wò ètò fifipamọ́ batiri tó bá jẹ́ pé awọn iranti ko dé.` |
| zh | `可靠送达` | `允许 Azkar 在后台运行，提醒才能准时到达。` | `允许后台活动` | `在某些手机（小米、华为、三星）上，如果提醒仍然漏掉，请检查省电设置。` |

### 7.3 Codegen
- [x] 7.3.1 Run `flutter gen-l10n` and confirm all 15 generated `app_localizations_*.dart` files include the new getters.

## 8. Verification

### 8.1 Static
- [x] 8.1.1 `flutter analyze` passes.
- [x] 8.1.2 `flutter build apk --debug` builds successfully.
- [ ] 8.1.3 `flutter build ios --debug --no-codesign` builds successfully (or `flutter build ipa --debug` if a Mac is available).

### 8.2 Android (real device, Android 13+)
- [ ] 8.2.1 Fresh install. Open Notifications page → both toggles off, no system prompt yet.
- [ ] 8.2.2 Toggle morning ON → permission prompt → Allow → toggle stays on. Time row shows "06:00".
- [ ] 8.2.3 Same flow → Deny → toggle snaps back, inline message shows.
- [ ] 8.2.4 Set morning to 1 minute from now, lock device → notification appears silently in status bar within ~5 min.
- [ ] 8.2.5 Tap notification → app opens to category 27 ("Morning and evening adhkar").
- [ ] 8.2.6 Reboot device → wait until scheduled time → notification still fires.
- [ ] 8.2.7 Disable in OS settings → reopen Notifications screen → inline "permission revoked" message appears.
- [ ] 8.2.8 Change language to Indonesian → notifications fire with Indonesian title "Saatnya zikir pagi".
- [ ] 8.2.9 With morning enabled but battery optimization NOT whitelisted → reopen Notifications screen → battery-optimization helper card appears.
- [ ] 8.2.10 Tap "Allow background activity" → OS dialog appears → grant → card disappears immediately on return.
- [ ] 8.2.11 Revoke battery optimization in OS settings → reopen Notifications screen → helper card reappears.

### 8.3 iOS (real device, iOS 15+)
- [ ] 8.3.1 Fresh install. Open Notifications page → toggles off, no system prompt yet.
- [ ] 8.3.2 Toggle morning ON → iOS permission sheet → Allow → toggle stays on.
- [ ] 8.3.3 Same flow → Don't Allow → toggle snaps back, inline message shows.
- [ ] 8.3.4 Set morning to 1 minute from now → lock screen → notification appears in Notification Center (no sound, no banner-with-vibration thanks to `interruptionLevel: passive`).
- [ ] 8.3.5 Tap notification → app opens to category 27.
- [ ] 8.3.6 Reboot device → wait until scheduled time → notification still fires.
- [ ] 8.3.7 Disable in iOS Settings → Notifications → Azkar → reopen screen → inline message appears.
- [ ] 8.3.8 Change language to Persian → notifications fire with Persian title.

## 8.5 Onboarding integration

- [x] 8.5.1 Add `flutter_timezone` to `pubspec.yaml`. Resolve device IANA TZ in `scheduler.init()` and call `tz.setLocalLocation(...)`. Without this, `tz.local` defaults to UTC and schedules fire at "06:00 UTC" not "06:00 local."
- [x] 8.5.2 Add `_ReminderSetup` slide as the 4th `PageView` child in `lib/ui/onboarding/screen.dart`. Position after Welcome / Language / Explainer.
- [x] 8.5.3 Update `_DotIndicator` count from 3 to 4. Update the "Get started" page-index check from `_pageIndex == 2` to `_pageIndex == 3`.
- [x] 8.5.4 Slide initializes `NotificationScheduler` in `didChangeDependencies` (idempotent — home-screen bootstrap is a no-op on second init).
- [x] 8.5.5 Two `_OnboardingReminderRow` widgets (morning + evening) — toggle + tap-to-edit time. Wire to the same `requestNotificationPermission` flow as the settings screen; on deny, snap the toggle back without showing an inline banner.
- [x] 8.5.6 Skip battery-optimization helper card on the onboarding slide. Surfaces later on the dedicated settings screen.
- [ ] 8.5.7 Manual: fresh-install → reach onboarding → enable morning + pick "in 2 minutes" → finish onboarding → wait → notification fires.
- [ ] 8.5.8 Manual: fresh-install → reach onboarding → deny notification permission → toggle snaps back → "Get started" still works.

## 9. Archive (post-deployment)
- [ ] 9.1 After this ships and any follow-up fixes are merged, archive via `openspec archive add-azkar-notifications --yes`.
