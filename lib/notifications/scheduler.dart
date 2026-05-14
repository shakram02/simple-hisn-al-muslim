import 'dart:io' show Platform;

import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Emits the destination category id whenever the user taps a notification.
///
/// Lives at the top level (not in the singleton) so background-isolate
/// callbacks can write to it without depending on the singleton being
/// already initialized in that isolate. `main.dart`'s `_buildHome`
/// listens for changes and pushes the corresponding category screen.
final ValueNotifier<int?> pendingTapCategoryId = ValueNotifier<int?>(null);

const _morningNotificationId = 1001;
const _eveningNotificationId = 1002;
const _channelId = 'azkar_reminder';

const _categoryPayloadKey = '27';

/// Background-isolate tap handler. MUST be a top-level / static function —
/// the plugin spawns a separate isolate to run this when the app process
/// is dead or backgrounded.
@pragma('vm:entry-point')
void _backgroundTapHandler(NotificationResponse response) {
  // Background isolate cannot directly push routes; the active foreground
  // isolate handles routing via `getNotificationAppLaunchDetails()` on
  // its next launch. Nothing to do here for v1.
}

/// Manages the morning + evening azkar reminder schedules.
///
/// Surfaces a single API the settings screen calls:
///   - [init] — registers the plugin, channel, permission flags.
///   - [requestNotificationPermission] — first-time permission flow.
///   - [areNotificationsEnabled] — current OS-level grant state.
///   - [scheduleMorning] / [scheduleEvening] / [cancelMorning] /
///     [cancelEvening] — idempotent reminder management.
///   - [reapplyFromPreferences] — used at app boot to ensure any
///     persisted reminder is re-armed against the current locale's title.
///   - [isBatteryOptimizationIgnored] /
///     [requestIgnoreBatteryOptimization] — Android-only helpers used
///     by the in-screen battery-optimization helper card.
///
/// All public methods are safe to call on iOS / web / desktop — they
/// degrade to platform-appropriate no-ops where the underlying capability
/// doesn't exist (e.g. battery-optimization on non-Android).
class NotificationScheduler {
  static final NotificationScheduler instance = NotificationScheduler._();
  NotificationScheduler._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// One-time plugin setup. [channelName] is the user-visible channel
  /// name in Android OS settings — resolve `AppLocalizations.of(context)
  /// .notificationsChannelName` and pass it. The channel name is sticky
  /// to whichever locale was active at first creation (Android caches it).
  Future<void> init({required String channelName}) async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    // CRITICAL: set tz.local to the device's actual timezone. Without
    // this, `tz.local` defaults to UTC and every "6 AM local" schedule
    // is computed against UTC — fires at whatever 6 AM UTC corresponds
    // to in the user's wall clock (e.g. 9 AM if they're in UTC+3).
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      // Best-effort: if the platform channel fails (extremely rare),
      // fall back to UTC. User can re-set their reminder time to
      // compensate; we just can't auto-detect.
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    // All permission flags false — we request explicitly via
    // [requestNotificationPermission] on the first toggle-ON.
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _foregroundTapHandler,
      onDidReceiveBackgroundNotificationResponse: _backgroundTapHandler,
    );

    if (Platform.isAndroid) {
      await _createAndroidChannel(channelName);
    }

    // Handle the "app was launched FROM a notification tap" case so the
    // very first frame routes to category 27.
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails!.notificationResponse?.payload;
      _routeFromPayload(payload);
    }

    _initialized = true;
  }

  Future<void> _createAndroidChannel(String channelName) async {
    final channel = AndroidNotificationChannel(
      _channelId,
      channelName,
      importance: Importance.defaultImportance,
      playSound: false,
      enableVibration: false,
      showBadge: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _foregroundTapHandler(NotificationResponse response) {
    _routeFromPayload(response.payload);
  }

  void _routeFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    final id = int.tryParse(payload);
    if (id != null) {
      pendingTapCategoryId.value = id;
    }
  }

  // ── Permission flow ─────────────────────────────────────────────

  /// Requests OS notification permission. Idempotent: if already
  /// granted, returns `true` without showing a prompt.
  ///
  /// Delegates to `permission_handler` instead of
  /// `flutter_local_notifications`' own permission methods. The
  /// flutter_local_notifications API has two foot-guns that made
  /// it impossible to enable a second reminder in sequence:
  ///
  ///   1. On Android, `requestNotificationsPermission()` returns the
  ///      dialog result on the FIRST call, but returns `null` on
  ///      subsequent calls when the user has already responded —
  ///      there's no fresh decision to surface, and `granted ?? false`
  ///      collapses to a phantom "denied".
  ///   2. `areNotificationsEnabled()` reports the current OS-level
  ///      state but conflates "freshly denied" with "permanently
  ///      denied (Don't ask again)" — once the user has denied twice
  ///      on Android 13+, the system suppresses the dialog forever
  ///      and the toggle silently flips back, with no way out except
  ///      a trip to Settings.
  ///
  /// `permission_handler` exposes a richer `PermissionStatus` enum
  /// (`granted` / `denied` / `permanentlyDenied` / `provisional` /
  /// `restricted`) that lets callers detect the "open Settings"
  /// case explicitly. `request()` is itself idempotent — calls
  /// against an already-granted permission return `granted`
  /// immediately without showing a dialog.
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.notification.status;
      if (status.isGranted || status.isProvisional) return true;
      if (status.isPermanentlyDenied || status.isRestricted) return false;
      status = await Permission.notification.request();
      return status.isGranted || status.isProvisional;
    }
    // Other platforms (desktop, web) — out of scope; report granted so
    // the UI flow doesn't get stuck on a permission gate that doesn't
    // exist on those platforms.
    return true;
  }

  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.notification.status;
      return status.isGranted || status.isProvisional;
    }
    return true;
  }

  /// True when the OS will never show the in-app permission dialog
  /// again — the user must visit system Settings to flip the toggle.
  /// Onboarding / settings UIs use this to swap a silent "no-op"
  /// switch for a "Open Settings" affordance.
  Future<bool> isNotificationPermissionPermanentlyDenied() async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;
    return Permission.notification.isPermanentlyDenied;
  }

  // ── Battery-optimization helper (Android only) ─────────────────

  Future<bool> isBatteryOptimizationIgnored() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.ignoreBatteryOptimizations.status;
    return status.isGranted;
  }

  Future<bool> requestIgnoreBatteryOptimization() async {
    if (!Platform.isAndroid) return true;
    final result = await Permission.ignoreBatteryOptimizations.request();
    return result.isGranted;
  }

  // ── Schedule / cancel ──────────────────────────────────────────

  Future<void> scheduleMorning(TimeOfDay time, String title, String body) async {
    await _schedule(_morningNotificationId, time, title, body);
  }

  Future<void> scheduleEvening(TimeOfDay time, String title, String body) async {
    await _schedule(_eveningNotificationId, time, title, body);
  }

  Future<void> cancelMorning() async {
    await _plugin.cancel(_morningNotificationId);
  }

  Future<void> cancelEvening() async {
    await _plugin.cancel(_eveningNotificationId);
  }

  Future<void> _schedule(int id, TimeOfDay time, String title, String body) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      'Azkar reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
      enableVibration: false,
      // Don't auto-cancel on tap — the user sees the title and chooses
      // to open. Default behavior of the package does auto-cancel which
      // is fine for our use case too. Keep default.
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      interruptionLevel: InterruptionLevel.passive,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // wallClockTime: when the user travels across time zones, the
      // reminder fires at the same local wall-clock time in the new
      // zone (not at the UTC instant of the original schedule). For
      // "daily 6 AM" semantics this is what users expect.
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: _categoryPayloadKey,
    );
  }

  // ── Re-apply from preferences ──────────────────────────────────

  /// Reads the persisted reminder preferences and replays the scheduling
  /// state: cancels disabled reminders, schedules enabled ones. Safe to
  /// call multiple times — `zonedSchedule` with the same notification ID
  /// replaces any prior schedule.
  ///
  /// [context] is needed to resolve the localized notification titles.
  /// The caller MUST pass a `BuildContext` that has `AppLocalizations`
  /// in scope.
  Future<void> reapplyFromPreferences(BuildContext context) async {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    final prefs = SettingsSharedPreferences();

    final morningEnabled = await prefs.getMorningReminderEnabled();
    if (morningEnabled) {
      final morningTime = await prefs.getMorningReminderTime();
      await scheduleMorning(
        morningTime,
        l10n.notificationMorningTitle,
        l10n.notificationMorningBody,
      );
    } else {
      await cancelMorning();
    }

    final eveningEnabled = await prefs.getEveningReminderEnabled();
    if (eveningEnabled) {
      final eveningTime = await prefs.getEveningReminderTime();
      await scheduleEvening(
        eveningTime,
        l10n.notificationEveningTitle,
        l10n.notificationEveningBody,
      );
    } else {
      await cancelEvening();
    }
  }
}

/// Singleton accessor (for use from places where reaching through
/// `NotificationScheduler.instance` is verbose).
NotificationScheduler get notificationScheduler => NotificationScheduler.instance;
