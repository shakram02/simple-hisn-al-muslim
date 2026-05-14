# Azkar Notifications — Spec Delta

## ADDED Requirements

### Requirement: Daily Morning Reminder

The app SHALL provide a per-user daily morning reminder notification. When enabled, the notification fires once per day at the user-chosen local time and contains the localized title text for the user's current chrome locale.

The reminder is **opt-in**: disabled by default until the user explicitly enables it. The default morning time is **06:00 local time**.

The notification SHALL:
- carry no sound and no vibration,
- show on the lock screen and in the status bar / Notification Center,
- be auto-dismissed when the user taps it,
- include a payload identifying category id `27` for tap navigation.

The notification SHALL NOT require any user action to fire each day once enabled — daily repetition happens automatically without the app being foregrounded.

#### Scenario: User enables the morning reminder
- **GIVEN** the user is on the Notifications settings screen
- **AND** the morning reminder is currently off
- **WHEN** the user toggles the morning reminder ON
- **AND** notification permission is granted (or already granted)
- **THEN** the system schedules a daily notification at the morning time
- **AND** the morning toggle persists in the ON state across app restarts

#### Scenario: Daily fire
- **GIVEN** the morning reminder is enabled at 06:00 local time
- **AND** the device is unlocked or locked, foregrounded or backgrounded
- **WHEN** the local clock reaches a time at or near 06:00
- **THEN** a silent notification appears with the localized morning title

#### Scenario: User disables the morning reminder
- **GIVEN** the morning reminder is enabled and scheduled
- **WHEN** the user toggles the morning reminder OFF
- **THEN** the pending notification schedule is cancelled
- **AND** no further morning notifications fire until the user re-enables

#### Scenario: User changes the morning time
- **GIVEN** the morning reminder is enabled at 06:00
- **WHEN** the user picks a new time via the time picker
- **THEN** the existing schedule is replaced with the new time
- **AND** the next occurrence fires at the new time

### Requirement: Daily Evening Reminder

The app SHALL provide a per-user daily evening reminder, mirroring the morning reminder in every respect except its default time (**17:00 local time**) and the notification title text ("Time for evening azkar" / localized equivalents).

The evening reminder operates **independently** of the morning reminder — either, both, or neither may be enabled.

#### Scenario: Both reminders enabled
- **GIVEN** the user has enabled both morning (06:00) and evening (17:00) reminders
- **WHEN** the local clock passes 06:00 and later 17:00 on the same day
- **THEN** two separate notifications fire — one at each time

#### Scenario: Only evening enabled
- **GIVEN** the morning reminder is OFF and the evening reminder is ON at 17:00
- **WHEN** the local clock reaches 06:00
- **THEN** no notification fires
- **AND** when the clock reaches 17:00, the evening notification fires

### Requirement: Notification Tap Navigation

Tapping either the morning or evening reminder notification SHALL open the app and navigate to the "Morning and evening adhkar" category (DB category id 27).

If the app is not running, it launches and routes to the category. If the app is already running, the user is brought to the foreground and lands on the category screen.

#### Scenario: Tap from cold launch
- **GIVEN** the app is not in memory
- **AND** the morning notification has fired
- **WHEN** the user taps the notification
- **THEN** the app launches
- **AND** completes its normal onboarding/boot flow
- **AND** finally pushes the "Morning and evening adhkar" category screen on top of the home

#### Scenario: Tap from warm launch
- **GIVEN** the app is in the background
- **WHEN** the user taps the notification
- **THEN** the app is brought to the foreground
- **AND** the "Morning and evening adhkar" category screen is shown

### Requirement: Notification Channel And Per-Platform Style

On Android, the app SHALL create exactly one notification channel for reminders, with the following characteristics:

- channel id: `azkar_reminder`
- channel name (user-visible in OS settings): localized "Azkar reminders" via the ARB key `notificationsChannelName`; the channel name is locale-sticky from first creation
- importance: `default`
- sound: none
- vibration: disabled
- show-on-lockscreen: yes
- show-badge: yes

On iOS, where notification channels don't exist, the app SHALL configure each notification with:
- `presentAlert: true`
- `presentBadge: true`
- `presentSound: false`
- `interruptionLevel: passive` (do not light the screen, do not present as a banner with a haptic — appear only in Notification Center)

The app SHALL NOT create per-reminder channels (one channel covers both morning and evening on Android).

#### Scenario: First-time channel creation on Android
- **WHEN** the app initializes the scheduler for the first time after install on Android
- **THEN** the `azkar_reminder` channel is created on the device
- **AND** the channel is visible in the OS notification settings

#### Scenario: iOS passive interruption
- **WHEN** an evening reminder fires on iOS
- **THEN** the notification appears in the Notification Center
- **AND** the device does not light its screen
- **AND** no haptic tap is delivered

### Requirement: Notification Content Has Title And Body

Each reminder notification SHALL include both a title and a body line. Both strings come from the localized ARB resources in the user's current chrome locale:
- Morning: `notificationMorningTitle` + `notificationMorningBody`
- Evening: `notificationEveningTitle` + `notificationEveningBody`

The body is a single short sentence that reinforces the title's intent (e.g. "A quiet moment to begin your day with remembrance."). It is rendered beneath the title in the system's standard two-line notification layout (Android: bold title + subtitle row; iOS: standard alert with title + message). The body does NOT change the channel's silence behavior — the notification remains sound-free and vibration-free regardless of content.

When the user changes the chrome locale, future notifications fire with the new locale's title and body (re-scheduled on next app open via `reapplyFromPreferences`).

#### Scenario: Title and body rendered in current locale
- **GIVEN** the user has selected `ar` as the chrome locale
- **WHEN** the morning notification fires
- **THEN** the notification title reads "حان وقت أذكار الصباح"
- **AND** the notification body reads "دقائق قليلة تبدأ بها يومك بذكر الله."
- **AND** both lines are visible on the lock screen and notification shade
- **AND** the notification still does not play sound or vibrate

#### Scenario: Title and body update after locale change
- **GIVEN** the morning reminder is enabled and previously scheduled with the Arabic title and body
- **WHEN** the user changes the chrome locale to English
- **AND** the app re-applies reminder schedules at boot or on the next opportunity
- **THEN** subsequent morning notifications fire with the title "Time for morning azkar"
- **AND** the body reads "A quiet moment to begin your day with remembrance."

### Requirement: Persistence Across App Restarts And Device Reboots

User reminder preferences (enabled state and time, per reminder) SHALL persist across:
- app restarts (including process death),
- app updates,
- device reboots.

Scheduled notifications SHALL continue to fire on schedule across device reboots without requiring the user to open the app after rebooting.

On Android this is achieved via `RECEIVE_BOOT_COMPLETED` + the package's auto-registered boot receiver. On iOS the system's `UNUserNotificationCenter` persists schedules across reboots natively.

#### Scenario: After app restart
- **GIVEN** the morning reminder is enabled at 06:00
- **WHEN** the app process is killed and relaunched
- **THEN** the Notifications screen shows the morning toggle ON and the time 06:00
- **AND** the scheduled notification continues to be queued for the next 06:00

#### Scenario: After device reboot
- **GIVEN** the morning reminder is enabled at 06:00
- **AND** the device is restarted
- **AND** the user does not open the app after the reboot
- **WHEN** the local clock next reaches 06:00
- **THEN** the silent notification fires

### Requirement: Notification Permission Handling

The app SHALL request the OS notification permission **only the first time the user attempts to enable a reminder**. The app SHALL NOT request the permission at launch or when the user merely opens the Notifications screen.

On Android 13+ (API 33+), the request is for `POST_NOTIFICATIONS`. On Android 12 and earlier, the permission is implicit (silent pass-through). On iOS, the request is for `alert + badge` via `UNUserNotificationCenter` (no sound flag because we never play sound).

If the user denies the permission, the requested toggle SHALL snap back to OFF and the screen SHALL show an inline message guiding the user to OS settings.

If the user later revokes the permission via OS settings while one or both toggles are stored as ON in the app's preferences, the Notifications screen SHALL display an inline message on entry indicating the OS-level permission is missing.

#### Scenario: First enable on Android 13+ — permission granted
- **GIVEN** the user is on Android 13 with no notification permission
- **AND** opens the Notifications screen
- **WHEN** the user toggles the morning reminder ON for the first time
- **THEN** the OS displays the `POST_NOTIFICATIONS` permission prompt
- **AND** the user selects "Allow"
- **THEN** the toggle remains ON
- **AND** the schedule is registered

#### Scenario: First enable on Android 13+ — permission denied
- **GIVEN** the user is on Android 13 with no notification permission
- **WHEN** the user toggles the morning reminder ON
- **AND** the user denies the OS permission prompt
- **THEN** the toggle snaps back to OFF
- **AND** an inline message appears explaining that notifications are disabled in device settings
- **AND** no schedule is registered

#### Scenario: First enable on iOS — permission granted
- **GIVEN** the user is on iOS with no notification permission for the app
- **WHEN** the user toggles the morning reminder ON for the first time
- **THEN** the iOS authorization sheet appears
- **AND** the user selects "Allow"
- **AND** the toggle remains ON
- **AND** the schedule is registered

#### Scenario: First enable on iOS — permission denied
- **GIVEN** the user is on iOS with no notification permission
- **WHEN** the user toggles the morning reminder ON
- **AND** the user selects "Don't Allow"
- **THEN** the toggle snaps back to OFF
- **AND** the inline message appears

#### Scenario: Permission revoked after enable
- **GIVEN** the user previously enabled the morning reminder and granted notification permission
- **AND** later revoked it in OS settings
- **WHEN** the user reopens the Notifications screen
- **THEN** an inline message appears indicating permission is missing
- **AND** the toggle visually reflects the user's intent (still ON in preferences) but the notification will not fire until permission is restored

### Requirement: Settings Screen

The app SHALL provide a dedicated settings screen for notifications, reachable from the side drawer as an entry labeled localized "Notifications".

The screen SHALL contain, in order:
- a brief intro line explaining what the screen controls,
- an inline permission-state banner (only visible when permission is missing while at least one reminder is enabled),
- a morning section: enable toggle + chosen-time display + tap-to-change-time affordance,
- an evening section: enable toggle + chosen-time display + tap-to-change-time affordance.

The screen SHALL NOT include a "Send test notification" button in v1.

#### Scenario: Open the screen from the drawer
- **GIVEN** the user has the side drawer open
- **WHEN** the user taps "Notifications"
- **THEN** the Notifications screen is pushed onto the navigation stack
- **AND** the AppBar title reads the localized `notificationsScreenTitle` string

#### Scenario: Time picker
- **GIVEN** the morning reminder is enabled at 06:00
- **WHEN** the user taps the morning time row
- **THEN** the OS time picker opens with the current value (06:00) preselected
- **AND** on confirmation, the new time is persisted and the schedule is updated

### Requirement: Battery-Optimization Helper (Android)

On Android, when at least one reminder is enabled AND the app is NOT on the OS battery-optimization whitelist, the Notifications settings screen SHALL surface a helper card with:

- a short title (`notificationsBatteryHelperTitle`),
- a one-line body explaining why background activity is needed (`notificationsBatteryHelperBody`),
- a primary action button (`notificationsBatteryHelperAction`) that, on tap, triggers the standard `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` OS dialog,
- a small footer hint (`notificationsBatteryHelperOemHint`) mentioning OEM-specific battery-saver settings as a fallback.

The card SHALL automatically hide once the app is whitelisted. It SHALL re-appear if the whitelist is revoked via OS settings.

The card SHALL NOT appear on iOS — iOS has no per-app battery-optimization concept; the card is suppressed unconditionally on iOS.

The app SHALL NOT attempt to programmatically override the user's battery-optimization decision; the system dialog is the only path. The app SHALL NOT include OEM-specific deep-links (e.g., to MIUI autostart settings) — those are out of scope.

#### Scenario: Helper card appears when needed
- **GIVEN** the user is on Android
- **AND** the user has enabled the morning reminder
- **AND** the app is NOT on the battery-optimization whitelist
- **WHEN** the user views the Notifications screen
- **THEN** the battery-optimization helper card is visible at the top of the screen

#### Scenario: User grants battery whitelist
- **GIVEN** the battery-optimization helper card is visible
- **WHEN** the user taps the primary action
- **AND** confirms in the OS dialog
- **THEN** the app is added to the OS battery-optimization whitelist
- **AND** the helper card disappears on the next screen rebuild

#### Scenario: User denies battery whitelist
- **GIVEN** the battery-optimization helper card is visible
- **WHEN** the user taps the primary action
- **AND** denies in the OS dialog
- **THEN** the card remains visible
- **AND** no further dialog or nag is shown for this session
- **AND** the card reappears on every subsequent visit until granted

#### Scenario: Card never appears on iOS
- **GIVEN** the user is on iOS
- **AND** has enabled the morning reminder
- **WHEN** the user views the Notifications screen
- **THEN** the battery-optimization helper card is NOT shown
- **AND** no battery-related affordance is rendered

#### Scenario: Helper card not shown when no reminders enabled
- **GIVEN** the user is on Android
- **AND** both reminder toggles are OFF
- **WHEN** the user views the Notifications screen
- **THEN** the battery-optimization helper card is NOT shown — there's nothing for the whitelist to protect

### Requirement: Onboarding Reminder-Setup Slide

The first-run onboarding flow SHALL include a dedicated slide for setting up morning and evening reminders. The slide SHALL be positioned as the final step before "Get started" (after Welcome, Language Picker, and How-to-Use slides).

The slide SHALL contain:
- a hero icon + the localized screen title (`notificationsScreenTitle`),
- a one-line intro line (`notificationsScreenIntro`),
- two reminder rows (morning + evening), each with:
  - the localized label (`notificationsMorningLabel` / `notificationsEveningLabel`),
  - a tap-to-edit time chip showing the current chosen time (defaults 06:00 / 17:00),
  - an enable toggle.

The slide SHALL render the battery-optimization helper card with the same predicate used by the dedicated settings screen: `Platform.isAndroid AND !batteryOptIgnored AND (morningEnabled || eveningEnabled)`. The card is implemented by a shared widget (`lib/ui/notifications/battery_helper_card.dart`) so the visual treatment is identical on both surfaces. The card itself does not auto-trigger any OS dialog — tapping its action button is what surfaces the battery-optimization request.

The slide SHALL NOT render the permission-revoked inline banner. First-run users have not been through the permission flow yet; the banner is a returning-user affordance that belongs on the dedicated settings page.

The slide content SHALL be vertically scrollable so the addition of the battery card does not cause RenderFlex overflow on small-screen devices.

The slide SHALL be optional. The user can advance to "Get started" without toggling either reminder — onboarding never gates completion on opt-in.

When the user toggles a reminder ON during onboarding, the standard permission flow applies:
- the OS notification-permission prompt fires on the first toggle-ON,
- on grant, the preference is persisted AND the schedule is registered immediately (no defer-until-after-onboarding),
- on deny, the toggle snaps back to OFF and the screen advances silently.

The scheduler SHALL be initialized when the slide enters the widget tree, not waited for until the home screen — so a user who opts in during onboarding has working reminders before they land on home.

#### Scenario: First-run user advances past the reminder slide without opting in
- **GIVEN** a brand-new install
- **AND** the user is on the reminder-setup slide
- **AND** both toggles are OFF
- **WHEN** the user taps "Get started"
- **THEN** onboarding completes
- **AND** the user lands on the home screen
- **AND** no permission prompt was shown
- **AND** no schedules are registered

#### Scenario: First-run user enables morning during onboarding
- **GIVEN** the user is on the reminder-setup slide
- **WHEN** the user toggles morning ON
- **AND** grants the OS notification permission
- **THEN** the morning reminder is scheduled at the current displayed time
- **AND** the toggle remains ON when the user returns to this slide

#### Scenario: First-run user denies the permission
- **GIVEN** the user is on the reminder-setup slide
- **WHEN** the user toggles morning ON
- **AND** denies the OS permission prompt
- **THEN** the toggle snaps back to OFF
- **AND** no inline banner is shown on the onboarding slide
- **AND** the user can still advance to "Get started"

#### Scenario: First-run user changes a time during onboarding
- **GIVEN** the user is on the reminder-setup slide
- **AND** morning is enabled at 06:00
- **WHEN** the user taps the morning time chip
- **AND** picks 07:30
- **THEN** the persisted time updates to 07:30
- **AND** the morning schedule is replaced with one firing at 07:30

#### Scenario: Battery-optimization card appears on enable (Android, not whitelisted)
- **GIVEN** the user is on the reminder-setup slide on Android
- **AND** the app is NOT yet on the OS battery-optimization whitelist
- **AND** both toggles are OFF
- **WHEN** the user toggles morning ON and grants notification permission
- **THEN** the battery-optimization helper card becomes visible beneath the reminder rows on the same slide
- **AND** the visual treatment matches the card shown on the dedicated settings screen
- **AND** no OS dialog has been triggered yet (the card is informational; the dialog is gated on the user tapping its action button)

#### Scenario: Battery-optimization card hidden when whitelisted
- **GIVEN** the user is on the reminder-setup slide on Android
- **AND** the app IS already on the OS battery-optimization whitelist
- **WHEN** the user toggles morning ON
- **THEN** the battery-optimization helper card does NOT appear
- **AND** the reminder is registered as scheduled

#### Scenario: Battery-optimization card never appears on iOS
- **GIVEN** the user is on the reminder-setup slide on iOS
- **WHEN** the user toggles morning ON
- **THEN** the battery-optimization helper card does NOT appear (iOS has no equivalent permission concept)

### Requirement: Device-Timezone Resolution

At scheduler initialization, the app SHALL resolve the device's actual IANA timezone (via `flutter_timezone.getLocalTimezone()`) and configure the `timezone` package's local zone accordingly. Without this, the package defaults to UTC and every scheduled-time calculation drifts by the device's UTC offset.

If the timezone-resolution call fails (extremely rare — platform-channel failure), the app SHALL fall back silently to UTC. A future call to `scheduler.init()` (e.g. next app launch) re-attempts the resolution.

#### Scenario: Scheduler init in a non-UTC timezone
- **GIVEN** the device is set to local timezone "Asia/Riyadh" (UTC+3)
- **WHEN** the scheduler initializes for the first time
- **THEN** `tz.local` is set to `tz.getLocation("Asia/Riyadh")`
- **AND** subsequent schedules for "06:00 local" compute the next occurrence in Riyadh local time
- **AND** the OS fires the notification at 06:00 Riyadh time (not 06:00 UTC)

#### Scenario: Scheduler init with platform-channel failure
- **GIVEN** the device's timezone cannot be read (platform exception)
- **WHEN** the scheduler initializes
- **THEN** the failure is swallowed silently
- **AND** `tz.local` remains its default (UTC)
- **AND** the user can still set reminder times, but the OS may fire them at a UTC-offset version of the chosen local time

### Requirement: Localization of Notification Strings

The app SHALL provide localized notification title strings + settings-screen chrome strings for all 15 supported content locales. The strings have been native-speaker-reviewed before implementation (see `tasks.md` section 7.2 for the locked text per locale).

When a locale lacks full chrome translations (per `Constants.chromeLocaleCodes`), the notification title falls back to English — consistent with the rest of the app's chrome fallback strategy. The reviewed translations cover all 15 locales, so no locale will actually hit the fallback.

The required ARB keys are:
- `notificationMorningTitle`
- `notificationEveningTitle`
- `notificationsScreenTitle`
- `notificationsScreenIntro`
- `notificationsMorningLabel`
- `notificationsEveningLabel`
- `notificationsChannelName`
- `notificationsPermissionDenied`
- `notificationsPermissionDeniedAction`

#### Scenario: Title in each shipped locale
- **WHEN** the morning notification fires for each of `ar, en, id, bn, bs, es, fa, ha, hi, pt, so, sw, th, yo, zh`
- **THEN** the title is rendered in the user's chrome locale per the locked strings in `tasks.md` section 7.2
