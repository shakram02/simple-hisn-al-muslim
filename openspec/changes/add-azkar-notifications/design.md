# Design: Daily Azkar Reminder Notifications

## Goals

1. A user who enables a reminder receives it every day at the chosen local time, including across device reboots, without ever opening the app again.
2. Zero audible interruption: no sound, no vibration.
3. Minimal permission friction: the OS permission prompt fires only the first time the user actually enables a reminder.
4. The feature is fully self-contained in a new module — no entanglement with the existing zikr-session or repo code.
5. **Both Android and iOS ship in v1.** No platform-deferral.

## Non-Goals

- Cross-device sync of reminder preferences.
- Multi-step actions on the notification itself (no "snooze", no "mark complete").
- Telemetry on whether reminders lead to actual app opens.
- Prayer-time-aware reminders (a fundamentally different feature requiring geolocation + prayer-time data).

## Architecture

```
┌──────────────────────────────┐
│ Settings → Notifications      │
│ (lib/ui/notifications/        │
│  screen.dart)                 │
└──────────┬───────────────────┘
           │ reads / writes prefs;
           │ calls scheduler API
           ▼
┌──────────────────────────────┐     ┌─────────────────────────────┐
│ NotificationsPreferences      │     │ NotificationScheduler        │
│ (lib/notifications/           │     │ (lib/notifications/          │
│  preferences.dart)            │     │  scheduler.dart)             │
│                               │     │                              │
│ - morningEnabled              │     │ - init()                     │
│ - morningTime  (TimeOfDay)    │     │ - requestPermission()        │
│ - eveningEnabled              │     │ - scheduleMorning(time)      │
│ - eveningTime  (TimeOfDay)    │     │ - scheduleEvening(time)      │
│                               │     │ - cancelMorning()            │
│ SharedPreferences-backed.     │     │ - cancelEvening()            │
└──────────────────────────────┘     │ - reapplyFromPreferences()   │
                                     └────────────┬────────────────┘
                                                  │ delegates to
                                                  ▼
                                     ┌─────────────────────────────┐
                                     │ flutter_local_notifications │
                                     │  ↳ Android: AlarmManager     │
                                     │      channel: "azkar_reminder"│
                                     │  ↳ iOS: UNUserNotificationCtr │
                                     │      DarwinInitSettings       │
                                     └─────────────────────────────┘
```

The scheduler is the **only** code that talks to `flutter_local_notifications`. The settings screen calls scheduler methods; `main.dart` calls `scheduler.init()` and `scheduler.reapplyFromPreferences()` at boot.

## Decisions

### Decision: use `flutter_local_notifications` (v17+)

- Maintained, ships boot-receiver wiring on Android, supports `zonedSchedule` with `matchDateTimeComponents: DateTimeComponents.time` for daily repeating on both Android + iOS.
- iOS path uses the system's `UNUserNotificationCenter` under the hood; the package exposes `DarwinInitializationSettings` for permission flags.
- Alternative considered: `awesome_notifications` — richer feature set we don't need; adds complexity.

### Decision: inexact alarms on Android (`AndroidScheduleMode.inexactAllowWhileIdle`)

- Android 12+ tightens exact-alarm policy. Requesting `SCHEDULE_EXACT_ALARM` triggers a "user must allow in settings" prompt that's hostile UX for a 6 AM reminder.
- Daily reminders don't need second-precision — a 5-15 min ±drift around the target time is acceptable for "morning azkar."
- iOS has no equivalent concept; iOS schedules fire at the target time within OS-managed scheduling.

### Decision: single notification channel "azkar_reminder" (Android), no channels on iOS

- **Android**: one channel for both morning + evening reminders. They have identical characteristics (silent, default importance, lock-screen-visible) — no reason for separate channels.
  - Channel ID: `azkar_reminder`. Display name in OS settings: localized "Azkar reminders".
  - Importance: `Importance.defaultImportance` — appears on lock screen, in shade, in status bar; visual but not audible.
  - Sound: null. Vibration: false.
- **iOS**: notification channels don't exist. We rely on per-notification settings via `DarwinNotificationDetails` (`presentSound: false`, `presentBadge: true`, `presentAlert: true`, `interruptionLevel: passive`).
  - `interruptionLevel: passive` means: don't light the screen, don't tap the user on the shoulder — just appear in the Notification Center. This is the iOS equivalent of "low-key persistent presence."

### Decision: notification IDs are fixed constants

- `morningNotificationId = 1001`, `eveningNotificationId = 1002`.
- Using stable IDs lets us idempotently reschedule on both platforms: scheduling with the same ID replaces the previous one — no orphan alarms or duplicate notifications.

### Decision: permission requested on-first-toggle-ON

- Don't ask on app boot — most users won't enable reminders and shouldn't be prompted.
- Don't ask on the settings page open — opening to look isn't intent to enable.
- **Android 13+**: when the user flips a reminder ON for the first time AND the permission isn't granted, request via the package's `requestNotificationsPermission()`. If denied, snap the toggle back to OFF and show a one-line inline hint that taps the OS app-settings.
- **iOS**: similar — on first enable, call `requestPermissions(alert: true, badge: true, sound: false)`. Same denied-fallback UX.
- Pre-Android-13 OSes have implicit permission; the prompt is skipped automatically by the package.

### Decision: reboot persistence

- **Android**: `flutter_local_notifications` auto-registers a `BOOT_COMPLETED` receiver when `RECEIVE_BOOT_COMPLETED` is declared in the manifest. On first launch after boot, the package re-arms pending zoned schedules.
- **iOS**: schedules persist in the system's `UNUserNotificationCenter` across reboots automatically; no app-side wiring needed.
- We still call `scheduler.reapplyFromPreferences()` in `main.dart` as a belt-and-suspenders measure — idempotent because `zonedSchedule` with the same notification ID replaces the prior schedule on both platforms.

### Decision: notification payload carries the destination category id

- Payload: stringified int `"27"` (the morning/evening adhkar category).
- On app launch from a tap, `main.dart` reads `getNotificationAppLaunchDetails()` and routes to the matching category screen via the existing `Navigator.push(MaterialPageRoute)` flow used by category-list tap.
- Same mechanism on both Android and iOS — package abstracts the platform difference.
- Future-proofing: payload structure can grow to JSON when we add more reminder types; for v1 a plain int is enough.

### Decision: time storage as `HH:MM` string

- `TimeOfDay` isn't directly persistable. Going with `"HH:MM"` — human-readable in the SharedPreferences XML file (useful for debugging), trivially parseable, locale-independent (uses 24h regardless of UI clock format).

### Decision: notification text is title-only

- Title: `حان وقت أذكار الصباح` / `Time for morning azkar` / locale equivalents (15 locales, native-speaker-reviewed).
- No body. A body would add a translation surface ×15 and risks reading as preachy. The title is enough information — the user knows what to do.

### Decision: settings screen layout

- New screen, not a dialog: more controls (2 toggles + 2 time pickers + a potential permission hint) than fit cleanly in a sheet.
- Reachable from the drawer's existing settings strip: insert "Notifications" entry between "Language" and the existing items.
- Visual vocabulary matches the drawer/category-list polish pass: cream surface, no card borders, subtle shadow on the time-picker rows.

### Decision: surface a battery-optimization helper card on Android

Android's Doze mode + OEM-specific battery killers (Xiaomi MIUI, Huawei EMUI, Samsung adaptive battery) can suppress scheduled alarms regardless of correct app configuration. For our use case (silent daily reminder), the risk profile is:

- **Stock Android Doze**: inexact alarms fire fine; drift ±5–15 min during deep Doze is acceptable for "morning azkar."
- **OEM aggressive killers**: can silently drop notifications. Even on the OS battery-optimization whitelist, some OEMs apply *additional* autostart-management restrictions in their own settings UIs.

Strategy:

1. **Detect** whether the app is currently on the OS battery-optimization whitelist via `permission_handler`'s `Permission.ignoreBatteryOptimizations.status`.
2. **Conditional surface**: when (a) at least one reminder is enabled AND (b) the app is NOT whitelisted, show a one-tap helper card on the Notifications screen. Card copy explains "for reliable reminder delivery" — frames it as recommended, not required.
3. **One-tap request**: tap the card's primary action → `Permission.ignoreBatteryOptimizations.request()` → OS shows the standard system whitelist-request dialog. User confirms or denies via the OS dialog (no programmatic override — Google Play policy mandates user consent).
4. **OEM-specific autostart-killers**: explicitly out of scope. We don't attempt to open `MIUI://Security/Autostart` or equivalent device-specific deep-links — too brittle, breaks on OS updates, varies per device. The card's hint text mentions "if reminders still don't fire, check your manufacturer's battery-saver settings" with no programmatic affordance.
5. **iOS**: no equivalent feature on iOS — the card never renders on iOS.

Google Play policy compliance: `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` is restricted to apps with legitimate background-execution needs. The Play policy explicitly lists "alarms, reminders, calendar events" as acceptable — we qualify.

### Decision: resolve device IANA timezone at scheduler init

The `timezone` Dart package defines `tz.local`, but it does NOT auto-detect the device's actual zone — its default is UTC unless explicitly set. Calling only `tz_data.initializeTimeZones()` (which loads the zone DATABASE) is a common Flutter mistake: data loaded, local not chosen.

Without the local-zone fix, `tz.TZDateTime(tz.local, year, month, day, 6, 0)` constructs "6 AM UTC", not "6 AM in the user's wall clock." For a user in UTC+3, the OS fires the notification at 09:00 their local time instead of 06:00.

Fix: in `scheduler.init()`, after the tz data loads, call:

```dart
final tzName = await FlutterTimezone.getLocalTimezone();  // e.g. "Africa/Cairo"
tz.setLocalLocation(tz.getLocation(tzName));
```

We use the `flutter_timezone` package because Dart's standard library only exposes the zone abbreviation (e.g. `"EET"`), not the IANA name needed by the timezone package. `flutter_timezone` is the maintained successor to the deprecated `flutter_native_timezone`.

Failure mode: if the platform channel call fails (rare), we swallow the exception and let `tz.local` remain at UTC. User can re-pick their reminder time to compensate. We do NOT crash, do NOT block init, do NOT block the user from using the rest of the app.

### Decision: onboarding integration as the 4th and final slide

The reminder-setup flow could have been positioned in three plausible places in onboarding:

| Position | Rationale | Trade-off |
|---|---|---|
| Before Welcome | "Permission ask first" | Hostile UX — user hasn't seen value yet |
| Between Language and Explainer | "Setup before learning" | Interrupts the educational arc |
| **After Explainer, before Get-Started** | "Last step before you start using it" | Natural progression: greet → orient → set up → begin |

We chose option 3. The user has been welcomed, picked their language, learned how the app works, and now has the natural "anything to configure before you start?" beat. Opting in here feels purposeful, not pushy.

Onboarding-specific simplifications vs the dedicated settings screen:
- **Battery-optimization helper card IS rendered, matching the settings screen.** Conditional on the same predicate: `Platform.isAndroid AND !batteryOptIgnored AND (morningEnabled || eveningEnabled)`. An earlier draft of this design omitted the card during onboarding on the theory that "three OS prompts is too much for first-run," but on reconsideration: (a) the card is passive — it only renders, it does NOT auto-trigger the battery-optimization request; the user has to tap the action button — so it's not actually a third prompt, just an informational affordance; (b) a user who opts into reminders during onboarding *should* learn at that moment that battery-optimization can suppress delivery, not days later in a settings menu after missing reminders. The same widget is used on both surfaces (`lib/ui/notifications/battery_helper_card.dart` — public `BatteryHelperCard`).
- **No permission-revoked banner.** First-run users have not yet been through the permission flow, so the banner ("Notifications are disabled in your device settings") is suppressed during onboarding. The banner is only meaningful on the dedicated settings screen where a returning user might re-discover their permission was revoked at OS level.
- **Reminders are optional.** Hitting "Get started" without toggling either reminder is supported and produces no friction.
- **Slide content is scrollable.** With the battery card rendered, the slide can exceed available height on small phones. Wrapping the slide body in `SingleChildScrollView` keeps it overflow-safe across screen sizes.

The slide initializes the scheduler in its `didChangeDependencies` (idempotent — the home screen's bootstrap is a no-op the second time around). This is the only place in the app where the scheduler init might happen BEFORE the home screen.

### Decision: default times 06:00 / 17:00

- **06:00 morning**: comfortably post-Fajr in most populated regions across seasons. 05:00 was at risk of firing pre-Fajr in summer in equatorial/southern latitudes — annoying users with a "morning adhkar" prompt before they should pray Fajr.
- **17:00 evening**: between Asr and Maghrib year-round in most populated regions. Earlier than 18:00 to ensure the reminder fires *before* Maghrib in winter (when Maghrib can be ~17:30 in higher latitudes). Reasonable middle ground.
- Users in extreme latitudes or with specific local schedules can always change the times via the settings page.

## Edge Cases

| Case | Behavior |
|---|---|
| User enables morning at 4 AM but device is currently 7 AM | Schedule fires at 4 AM the NEXT day. No backfire of missed times. |
| User changes morning from 06:00 to 07:00 at 06:30 | Today's 06:00 has already fired. Reschedule to 07:00 tomorrow. (`zonedSchedule` with the new time skips past occurrences automatically.) |
| User toggles morning OFF | Cancel the scheduled notification immediately. Preference saved as `morningEnabled=false`. The chosen time is preserved for when they re-enable. |
| User uninstalls and reinstalls | All schedules + prefs are gone (both platforms). Fresh state on reinstall. Acceptable. |
| User clears OS notification permission | Next call to `scheduler.scheduleMorning(...)` is no-op'd by the OS. The Settings screen detects this via the package's `areNotificationsEnabled()` and shows the inline "permission revoked" message. |
| Device booted, user hasn't opened app yet (Android) | OS-level `BOOT_COMPLETED` receiver fires; package re-arms previously-set zoned schedules. Works without app being opened. |
| Device booted, user hasn't opened app yet (iOS) | iOS handles persistence natively; the previously-scheduled `UNNotificationRequest` continues firing on schedule. |
| User's device time changes (timezone travel, manual clock change) | `zonedSchedule` uses the local zone observed at fire time. After timezone change, the package re-checks on next boot or first app open. For travel scenarios, we accept a one-day potential drift — `reapplyFromPreferences()` on app open will re-anchor. |
| Notification fires while the app is foregrounded | Default package behavior: show in shade, app's UI is unaffected. No custom in-app banner. |
| iOS user toggles "Allow Notifications" off after granting | Same as Android: next app open, settings screen shows inline "permission revoked" message. |
| Android user has a reminder enabled but battery optimization NOT whitelisted | The Notifications screen shows the helper card. Tap → OS battery-optimization request dialog. On grant, card disappears. On deny, card stays visible (no nag — same surface every visit until granted). |
| Android user grants battery whitelist then revokes via OS settings later | Next visit to Notifications screen: helper card reappears. |
| Android user is on an OEM (Xiaomi/Huawei/etc.) where notifications are killed despite whitelist | Helper card's secondary hint text mentions "if reminders still don't fire reliably, check your manufacturer's battery-saver settings." We don't deep-link to OEM-specific screens. |

## Test Plan (Manual — both platforms)

**Android 13+**:
1. Fresh install: notifications page shows both toggles off, no permission prompt yet.
2. Toggle morning ON: permission prompt appears. Allow → toggle stays on, time row shows "06:00". Deny → toggle snaps back, inline message shows.
3. Change time via picker: time persists across app restarts (check SharedPreferences XML).
4. Set morning to 1 minute from now, toggle on, lock device → notification appears silently.
5. Tap notification → app launches/foregrounds and opens category 27.
6. Reboot device → wait until scheduled time → notification still fires.
7. Disable in OS settings → reopen notifications page → inline "permission revoked" message appears.

**iOS 15+**:
1. Fresh install: same — toggles off, no prompt.
2. Toggle morning ON: system permission sheet appears. Allow → toggle stays on. Deny → toggle snaps back, inline message shows.
3. Set morning to 1 minute from now, lock screen → notification appears silently (`presentSound: false`).
4. Tap notification → app opens to category 27.
5. Reboot device → wait until scheduled time → notification still fires.
6. Disable in iOS Settings → Notifications → Azkar → reopen notifications page → inline "permission revoked" message appears.

## Risks

- **Package version drift**: `flutter_local_notifications` major versions have had breaking changes historically. Pin a specific minor (e.g. `^17.2.0`) to avoid silent regressions.
- **Android OEM aggressive killers** (Xiaomi MIUI, Huawei EMUI, Samsung One UI battery savers) can suppress alarms regardless of correct configuration. Out of scope — documented as a known limitation if support questions surface.
- **Android Doze mode batching**: inexact alarms during Doze can drift up to ~15 minutes from the chosen time. Acceptable for "morning azkar" granularity, but worth noting if a user reports the notification firing "late."
- **iOS background limitations**: iOS 15+ honors `interruptionLevel: passive` strictly — no notification will light up the screen. That's the intent.
