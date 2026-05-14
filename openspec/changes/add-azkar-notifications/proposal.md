# Change: Add Daily Morning & Evening Azkar Reminder Notifications

## Why

The app is a daily-habit tool, but users currently have to remember to open it. Morning and evening azkar are time-bound observances; a quiet, dependable notification at the right time turns the app from "I'll open it when I think of it" into "the app prompts me when it's time." This is the highest-leverage feature for retention and for the app's actual purpose — encouraging consistent practice.

We deliberately keep the surface small: just morning + evening, just a title, silent, no body, opt-in.

## What Changes

- **New capability `azkar-notifications`** owning everything notification-related.
- **New dependency**: `flutter_local_notifications` (industry-standard, supports daily scheduling, channel control, boot persistence, both Android and iOS).
- **Two daily scheduled notifications**, one for morning azkar and one for evening azkar. Each runs independently — user can enable both, one, or neither.
- **Defaults**: morning at **06:00**, evening at **17:00** (chosen to fall comfortably between Fajr/sunrise and Asr/Maghrib year-round in most populated regions — 05:00 risked firing pre-Fajr in some seasons). Both disabled by default until the user opts in.
- **Silent**: no sound, no vibration. On Android, `Importance.defaultImportance` (visible on lock screen, in shade, in status bar). On iOS, alert + badge enabled, sound disabled.
- **Localized notification text** for all 15 locales, native-speaker-reviewed before implementation. Each reminder ships with both a **title** and a **body line** so the notification reads as two visible lines on both Android and iOS — title bolded, body underneath in normal weight — rather than a single bare line. Examples:
  - Morning title: `حان وقت أذكار الصباح` / `Time for morning azkar` / `Saatnya zikir pagi` / …
  - Morning body: `دقائق قليلة تبدأ بها يومك بذكر الله.` / `A quiet moment to begin your day with remembrance.` / `Sejenak untuk memulai hari dengan zikir kepada Allah.` / …
  - Evening title: `حان وقت أذكار المساء` / `Time for evening azkar` / `Saatnya zikir petang` / …
  - Evening body: `دقائق قليلة تختم بها يومك بذكر الله.` / `A quiet moment to close your day with remembrance.` / `Sejenak untuk menutup hari dengan zikir kepada Allah.` / …
- **New settings screen** "Notifications", reachable from the side drawer. Contains:
  - Morning section: enable toggle + time picker.
  - Evening section: enable toggle + time picker.
  - Inline state messages for the "permission revoked at OS level" case.
- **Permission handling**:
  - **Android 13+**: request `POST_NOTIFICATIONS` the first time the user toggles a reminder ON. If denied, leave the toggle visually OFF and show a quiet inline hint.
  - **iOS**: request alert + badge authorization on first toggle-ON via `DarwinInitializationSettings`. If denied, same fallback as Android.
- **Reboot persistence**:
  - **Android**: `RECEIVE_BOOT_COMPLETED` + the package's auto-registered boot receiver re-arms zoned schedules after reboot.
  - **iOS**: schedules persist automatically across reboots via the system; no app code needed.
- **Inexact alarms on Android** (no `SCHEDULE_EXACT_ALARM`): a ±5–15 min batching window is acceptable for daily reminders and avoids the special-permission UX. iOS has no exact-alarm permission concept.
- **Tap action (both platforms)**: tapping either notification opens the app on the "Morning and evening adhkar" category (DB category 27 — both flavors share a single category in the data).
- **Battery-optimization helper (Android only)**: when a reminder is enabled AND the app is NOT on the OS battery-optimization whitelist, the Notifications screen surfaces a one-tap helper card. Tap → OS system dialog to whitelist the app. This counters Doze-mode and OEM-killer suppression for users who care about reliable delivery. We detect via `permission_handler`'s `Permission.ignoreBatteryOptimizations` and request via the standard system request flow (no programmatic override — Play policy requires user consent).
- **Device-timezone resolution**: the scheduler resolves the device's actual IANA timezone (via `flutter_timezone`) at init and calls `tz.setLocalLocation(...)` so `tz.local` reflects the user's wall-clock zone. Without this, `tz.local` defaults to UTC and every "06:00 local" schedule fires at 06:00 UTC — off by the device's UTC offset.
- **Onboarding integration**: a new 4th slide in the onboarding `PageView` (after Welcome / Language / Explainer, before "Get started"). The slide mirrors the dedicated settings page: two reminder rows (morning + evening) with default times 06:00 / 17:00 and inline time pickers, and — once the user enables at least one reminder on Android — the same battery-optimization helper card that appears on the settings screen (rendered via a shared `BatteryHelperCard` widget). The slide is optional: a user can advance past it without enabling anything. When a user toggles a reminder ON during onboarding, the standard permission flow fires and the schedule is registered immediately.

This change ships **fully feature-complete across Android and iOS on day one** — no platform deferred.

## Impact

**Affected capabilities**
- New: `azkar-notifications`
- Touched (drawer entry only): no spec yet for app-shell; no spec delta needed there.

**Affected code (new files)**
- `lib/notifications/scheduler.dart` — wraps `flutter_local_notifications`, owns channel + iOS category setup, permission requests, and the schedule/cancel API used by the settings page.
- `lib/notifications/preferences.dart` — extends `SettingsSharedPreferences` with the 4 reminder keys (morning enabled, morning time, evening enabled, evening time).
- `lib/ui/notifications/screen.dart` — the new dedicated settings screen.

**Affected code (modified)**
- `lib/main.dart` — ensure the scheduler is initialized at app boot; handle notification-tap launch payload to deep-link into category 27.
- `lib/ui/drawer/menu.dart` — add a "Notifications" entry below "Language" that pushes the new screen.
- `lib/l10n/app_*.arb` (15 files) — add notification title strings + the settings-page chrome strings + the battery-optimization helper strings.
- `android/app/src/main/AndroidManifest.xml` — declare `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`, and the `flutter_local_notifications` boot + scheduled-notification receivers.
- `ios/Runner/Info.plist` — no Info.plist entries are required for the basic alert+badge flow (Apple grants the permission via the standard `UNUserNotificationCenter` request at runtime); if a future change adds critical alerts or notification-extension capabilities they'd be added there.
- `ios/Runner/AppDelegate.swift` — register the plugin per `flutter_local_notifications` iOS setup steps (single line: `FlutterLocalNotificationsPlugin.setPluginRegistrantCallback(...)`).
- `pubspec.yaml` — add `flutter_local_notifications`, `permission_handler` (battery-optimization permission flow), and `flutter_timezone` (resolve device IANA TZ at init).
- `lib/ui/onboarding/screen.dart` — add the 4th `_ReminderSetup` slide; bump dot indicator count from 3 to 4; update "Get started" page-index check.

**Out of scope (genuinely a different feature, not deferred completeness)**
- Prayer-time-aware reminders (would require pulling prayer-time data per geolocation — a separate feature entirely, not part of this one).
- Customizable reminder labels, more-than-two reminders, "snooze" actions on the notification.
- Per-reminder body content beyond the title (the title is sufficient by design).
- A test-notification button (would be a debugging aid, not part of the feature surface). Easy to add later if users request it.
- OEM-specific deep-links into Xiaomi/Huawei/Samsung autostart-management screens. These vary by manufacturer and OS version; reliably opening them requires per-device package-name probing that's high-maintenance and brittle. Standard `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` handles the OS-level Doze case; OEM-specific autostart-killers remain a known limitation flagged in the helper card's hint text.
