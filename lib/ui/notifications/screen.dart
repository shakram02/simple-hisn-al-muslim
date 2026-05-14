import 'dart:io' show Platform;

import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/notifications/scheduler.dart';
import 'package:azkar/ui/app_bar.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/notifications/battery_helper_card.dart';
import 'package:azkar/ui/notifications/reminder_row.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final SettingsSharedPreferences _prefs = SettingsSharedPreferences();
  bool _loading = true;

  bool _morningEnabled = false;
  bool _eveningEnabled = false;
  TimeOfDay _morningTime = SettingsSharedPreferences.defaultMorningTime;
  TimeOfDay _eveningTime = SettingsSharedPreferences.defaultEveningTime;
  bool _osPermissionGranted = true;
  bool _batteryOptIgnored = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final morningEnabled = await _prefs.getMorningReminderEnabled();
    final morningTime = await _prefs.getMorningReminderTime();
    final eveningEnabled = await _prefs.getEveningReminderEnabled();
    final eveningTime = await _prefs.getEveningReminderTime();
    final perm = await NotificationScheduler.instance
        .areNotificationsEnabled();
    final batt = await NotificationScheduler.instance
        .isBatteryOptimizationIgnored();
    if (!mounted) return;
    setState(() {
      _morningEnabled = morningEnabled;
      _eveningEnabled = eveningEnabled;
      _morningTime = morningTime;
      _eveningTime = eveningTime;
      _osPermissionGranted = perm;
      _batteryOptIgnored = batt;
      _loading = false;
    });
  }

  Future<void> _toggleMorning(bool wanted) async {
    final l10n = AppLocalizations.of(context);
    if (wanted) {
      final granted = await NotificationScheduler.instance
          .requestNotificationPermission();
      if (!granted) {
        if (!mounted) return;
        setState(() {
          _morningEnabled = false;
          _osPermissionGranted = false;
        });
        return;
      }
      await _prefs.saveMorningReminderEnabled(true);
      await NotificationScheduler.instance.scheduleMorning(
        _morningTime,
        l10n.notificationMorningTitle,
        l10n.notificationMorningBody,
      );
      if (!mounted) return;
      setState(() {
        _morningEnabled = true;
        _osPermissionGranted = true;
      });
    } else {
      await _prefs.saveMorningReminderEnabled(false);
      await NotificationScheduler.instance.cancelMorning();
      if (!mounted) return;
      setState(() => _morningEnabled = false);
    }
    await _refreshBatteryOptStatus();
  }

  Future<void> _toggleEvening(bool wanted) async {
    final l10n = AppLocalizations.of(context);
    if (wanted) {
      final granted = await NotificationScheduler.instance
          .requestNotificationPermission();
      if (!granted) {
        if (!mounted) return;
        setState(() {
          _eveningEnabled = false;
          _osPermissionGranted = false;
        });
        return;
      }
      await _prefs.saveEveningReminderEnabled(true);
      await NotificationScheduler.instance.scheduleEvening(
        _eveningTime,
        l10n.notificationEveningTitle,
        l10n.notificationEveningBody,
      );
      if (!mounted) return;
      setState(() {
        _eveningEnabled = true;
        _osPermissionGranted = true;
      });
    } else {
      await _prefs.saveEveningReminderEnabled(false);
      await NotificationScheduler.instance.cancelEvening();
      if (!mounted) return;
      setState(() => _eveningEnabled = false);
    }
    await _refreshBatteryOptStatus();
  }

  Future<void> _pickMorningTime() async {
    // Resolve localized strings BEFORE the async picker so we don't have
    // to touch context after awaiting (analyzer flags that pattern).
    final l10n = AppLocalizations.of(context);
    final title = l10n.notificationMorningTitle;
    final body = l10n.notificationMorningBody;
    final picked = await showTimePicker(
      context: context,
      initialTime: _morningTime,
    );
    if (picked == null || !mounted) return;
    await _prefs.saveMorningReminderTime(picked);
    if (_morningEnabled) {
      await NotificationScheduler.instance.scheduleMorning(picked, title, body);
    }
    if (!mounted) return;
    setState(() => _morningTime = picked);
  }

  Future<void> _pickEveningTime() async {
    final l10n = AppLocalizations.of(context);
    final title = l10n.notificationEveningTitle;
    final body = l10n.notificationEveningBody;
    final picked = await showTimePicker(
      context: context,
      initialTime: _eveningTime,
    );
    if (picked == null || !mounted) return;
    await _prefs.saveEveningReminderTime(picked);
    if (_eveningEnabled) {
      await NotificationScheduler.instance.scheduleEvening(picked, title, body);
    }
    if (!mounted) return;
    setState(() => _eveningTime = picked);
  }

  Future<void> _requestBatteryOptOut() async {
    final granted = await NotificationScheduler.instance
        .requestIgnoreBatteryOptimization();
    if (!mounted) return;
    setState(() => _batteryOptIgnored = granted);
  }

  Future<void> _refreshBatteryOptStatus() async {
    final batt = await NotificationScheduler.instance
        .isBatteryOptimizationIgnored();
    if (!mounted) return;
    setState(() => _batteryOptIgnored = batt);
  }

  Future<void> _openAppSettings() async {
    await ph.openAppSettings();
    // Re-check on return (best-effort — user may not have changed anything).
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);

    if (_loading) {
      return Scaffold(
        appBar: ZikrAppBar.getAppBar(
          title: l10n.notificationsScreenTitle,
          context: context,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final permissionBannerVisible =
        !_osPermissionGranted && (_morningEnabled || _eveningEnabled);
    final batteryHelperVisible = Platform.isAndroid &&
        !_batteryOptIgnored &&
        (_morningEnabled || _eveningEnabled);

    return Scaffold(
      appBar: ZikrAppBar.getAppBar(
        title: l10n.notificationsScreenTitle,
        context: context,
      ),
      // top: false — AppBar handles the status-bar inset. Bottom
      // inset reserves space so the last reminder row isn't clipped
      // under the gesture-nav bar on Android 15 edge-to-edge.
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
            child: Text(
              l10n.notificationsScreenIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
          ),
          if (permissionBannerVisible)
            _PermissionBanner(
              message: l10n.notificationsPermissionDenied,
              actionLabel: l10n.notificationsPermissionDeniedAction,
              onAction: _openAppSettings,
            ),
          if (batteryHelperVisible)
            BatteryHelperCard(
              title: l10n.notificationsBatteryHelperTitle,
              body: l10n.notificationsBatteryHelperBody,
              action: l10n.notificationsBatteryHelperAction,
              oemHint: l10n.notificationsBatteryHelperOemHint,
              onAction: _requestBatteryOptOut,
            ),
          ReminderRow(
            label: l10n.notificationsMorningLabel,
            time: _morningTime,
            enabled: _morningEnabled,
            onToggle: _toggleMorning,
            onTapTime: _pickMorningTime,
          ),
          const SizedBox(height: 10),
          ReminderRow(
            label: l10n.notificationsEveningLabel,
            time: _eveningTime,
            enabled: _eveningEnabled,
            onToggle: _toggleEvening,
            onTapTime: _pickEveningTime,
          ),
        ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────

class _PermissionBanner extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _PermissionBanner({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Banner-specific gold accent (icon + action button) reads stronger
    // at shade700 on light backgrounds and shade300 on dark. This is
    // local to the banner — not a candidate for AppColors which only
    // exposes the single-shade `secondary`.
    final accent = isDark
        ? AppTheme.secondaryColor.shade300
        : AppTheme.secondaryColor.shade700;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        // Banner background is a translucent secondary-tinted surface
        // (the "alert" affordance) — alpha is brightness-dependent.
        color: AppTheme.secondaryColor.shade50.withValues(
          alpha: isDark ? 0.20 : 1.0,
        ),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, color: accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
            ),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: accent),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

