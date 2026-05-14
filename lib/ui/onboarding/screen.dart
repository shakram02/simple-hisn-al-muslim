import 'dart:io' show Platform;

import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/model.dart';
import 'package:azkar/notifications/scheduler.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/components/soft_card.dart';
import 'package:azkar/ui/notifications/battery_helper_card.dart';
import 'package:azkar/ui/notifications/reminder_row.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';

/// Three-page onboarding shown on the first true launch of the app
/// (or skipped silently for upgrading users — see main.dart).
class OnboardingScreen extends StatefulWidget {
  final String initialLocaleCode;
  final Function(String) onLocaleChanged;
  final VoidCallback onFinished;

  const OnboardingScreen({
    super.key,
    required this.initialLocaleCode,
    required this.onLocaleChanged,
    required this.onFinished,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;
  late String _localeCode;
  List<AppLocale> _locales = const [];

  @override
  void initState() {
    super.initState();
    _localeCode = widget.initialLocaleCode;
    _loadLocales();
  }

  Future<void> _loadLocales() async {
    final loaded = await ZikrRepository().loadLocales();
    if (!mounted) return;
    setState(() => _locales = loaded);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _advance() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    await SettingsSharedPreferences().saveOnboardingCompleted(true);
    if (!mounted) return;
    widget.onFinished();
  }

  void _pickLocale(String code) {
    setState(() => _localeCode = code);
    widget.onLocaleChanged(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final accent = colors.primary;
    final mutedAccent = colors.iconMuted;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _pageIndex = i),
                children: [
                  _Welcome(l10n: l10n, accent: accent),
                  _LanguagePicker(
                    l10n: l10n,
                    locales: _locales,
                    selected: _localeCode,
                    onPick: _pickLocale,
                    accent: accent,
                  ),
                  _Explainer(l10n: l10n, accent: accent),
                  _ReminderSetup(l10n: l10n, accent: accent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  _DotIndicator(
                    count: 4,
                    index: _pageIndex,
                    activeColor: accent,
                    mutedColor: mutedAccent,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _pageIndex == 3 ? _finish : _advance,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _pageIndex == 2
                            ? l10n.onboardingGetStarted
                            : l10n.onboardingContinue,
                        // titleSmall on white-on-accent — same 15/600
                        // rhythm as other titled affordances.
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Slide 1 — Welcome

class _Welcome extends StatelessWidget {
  final AppLocalizations l10n;
  final Color accent;
  const _Welcome({
    required this.l10n,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bodyColor = colors.textTertiary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.accentTintBg,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.menu_book_rounded, color: accent, size: 32),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.onboardingWelcome,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 14),
          Text(
            l10n.onboardingDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bodyColor,
                ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Slide 2 — Language picker

class _LanguagePicker extends StatelessWidget {
  final AppLocalizations l10n;
  final List<AppLocale> locales;
  final String selected;
  final Function(String) onPick;
  final Color accent;

  const _LanguagePicker({
    required this.l10n,
    required this.locales,
    required this.selected,
    required this.onPick,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        children: [
          Text(
            l10n.onboardingPickLanguage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          if (locales.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: locales.length,
                itemBuilder: (context, index) {
                  final l = locales[index];
                  return _LocaleTile(
                    locale: l,
                    isSelected: l.code == selected,
                    accent: accent,
                    onTap: () => onPick(l.code),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _LocaleTile extends StatelessWidget {
  final AppLocale locale;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  const _LocaleTile({
    required this.locale,
    required this.isSelected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final tintedBg = isSelected ? colors.accentTintBg : colors.surface;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
        decoration: BoxDecoration(
          color: tintedBg,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: isSelected ? null : colors.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                locale.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? accent : colors.textPrimary,
                    ),
                // Override Directionality so Persian/Arabic native
                // names render correctly even when current chrome is LTR.
                textDirection: Constants.rtlLocaleCodes.contains(locale.code)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ),
            const SizedBox(width: 12),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: accent, size: 22)
            else
              Icon(Icons.circle_outlined, color: colors.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Slide 3 — Explainer

class _Explainer extends StatelessWidget {
  final AppLocalizations l10n;
  final Color accent;
  const _Explainer({
    required this.l10n,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HintCard(
            icon: Icons.touch_app_rounded,
            title: l10n.onboardingTapToCountTitle,
            body: l10n.onboardingTapToCountBody,
            accent: accent,
          ),
          const SizedBox(height: 14),
          _HintCard(
            icon: Icons.swap_horiz_rounded,
            title: l10n.onboardingSwipeTitle,
            body: l10n.onboardingSwipeBody,
            accent: accent,
          ),
        ],
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  const _HintCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bodyColor = colors.textTertiary;
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 18, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.accentTintBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bodyColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Slide 4 — Daily reminder setup (opt-in)

class _ReminderSetup extends StatefulWidget {
  final AppLocalizations l10n;
  final Color accent;
  const _ReminderSetup({
    required this.l10n,
    required this.accent,
  });

  @override
  State<_ReminderSetup> createState() => _ReminderSetupState();
}

class _ReminderSetupState extends State<_ReminderSetup> {
  final SettingsSharedPreferences _prefs = SettingsSharedPreferences();
  bool _bootstrapped = false;

  bool _morningEnabled = false;
  bool _eveningEnabled = false;
  TimeOfDay _morningTime = SettingsSharedPreferences.defaultMorningTime;
  TimeOfDay _eveningTime = SettingsSharedPreferences.defaultEveningTime;
  // Default true so the helper card doesn't briefly flash before the
  // async battery-status check returns. On iOS the value stays true.
  bool _batteryOptIgnored = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the scheduler the first time this slide enters the
    // widget tree — so the permission flow + scheduling work when the
    // user toggles a reminder ON during onboarding (before the home
    // screen's bootstrap fires).
    if (!_bootstrapped) {
      _bootstrapped = true;
      _initScheduler();
    }
  }

  Future<void> _initScheduler() async {
    await NotificationScheduler.instance.init(
      channelName: widget.l10n.notificationsChannelName,
    );
    if (!mounted) return;
    // Read any pre-existing preferences (e.g. if the user came back to
    // onboarding via a debug reset). For a true first-launch, these are
    // just the defaults.
    final morningEnabled = await _prefs.getMorningReminderEnabled();
    final eveningEnabled = await _prefs.getEveningReminderEnabled();
    final morningTime = await _prefs.getMorningReminderTime();
    final eveningTime = await _prefs.getEveningReminderTime();
    final batt = await NotificationScheduler.instance
        .isBatteryOptimizationIgnored();
    if (!mounted) return;
    setState(() {
      _morningEnabled = morningEnabled;
      _eveningEnabled = eveningEnabled;
      _morningTime = morningTime;
      _eveningTime = eveningTime;
      _batteryOptIgnored = batt;
    });
  }

  Future<void> _refreshBatteryOptStatus() async {
    final batt = await NotificationScheduler.instance
        .isBatteryOptimizationIgnored();
    if (!mounted) return;
    setState(() => _batteryOptIgnored = batt);
  }

  Future<void> _requestBatteryOptOut() async {
    final granted = await NotificationScheduler.instance
        .requestIgnoreBatteryOptimization();
    if (!mounted) return;
    setState(() => _batteryOptIgnored = granted);
  }

  Future<void> _toggleMorning(bool wanted) async {
    if (wanted) {
      final granted = await NotificationScheduler.instance
          .requestNotificationPermission();
      if (!granted) {
        if (!mounted) return;
        setState(() => _morningEnabled = false);
        return;
      }
      await _prefs.saveMorningReminderEnabled(true);
      await NotificationScheduler.instance.scheduleMorning(
        _morningTime,
        widget.l10n.notificationMorningTitle,
        widget.l10n.notificationMorningBody,
      );
      if (!mounted) return;
      setState(() => _morningEnabled = true);
    } else {
      await _prefs.saveMorningReminderEnabled(false);
      await NotificationScheduler.instance.cancelMorning();
      if (!mounted) return;
      setState(() => _morningEnabled = false);
    }
    await _refreshBatteryOptStatus();
  }

  Future<void> _toggleEvening(bool wanted) async {
    if (wanted) {
      final granted = await NotificationScheduler.instance
          .requestNotificationPermission();
      if (!granted) {
        if (!mounted) return;
        setState(() => _eveningEnabled = false);
        return;
      }
      await _prefs.saveEveningReminderEnabled(true);
      await NotificationScheduler.instance.scheduleEvening(
        _eveningTime,
        widget.l10n.notificationEveningTitle,
        widget.l10n.notificationEveningBody,
      );
      if (!mounted) return;
      setState(() => _eveningEnabled = true);
    } else {
      await _prefs.saveEveningReminderEnabled(false);
      await NotificationScheduler.instance.cancelEvening();
      if (!mounted) return;
      setState(() => _eveningEnabled = false);
    }
    await _refreshBatteryOptStatus();
  }

  Future<void> _pickMorningTime() async {
    final title = widget.l10n.notificationMorningTitle;
    final body = widget.l10n.notificationMorningBody;
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
    final title = widget.l10n.notificationEveningTitle;
    final body = widget.l10n.notificationEveningBody;
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bodyColor = colors.textTertiary;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.accentTintBg,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_outlined,
              color: widget.accent,
              size: 30,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.l10n.notificationsScreenTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            widget.l10n.notificationsScreenIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bodyColor,
                ),
          ),
          const SizedBox(height: 22),
          ReminderRow(
            label: widget.l10n.notificationsMorningLabel,
            time: _morningTime,
            enabled: _morningEnabled,
            onToggle: _toggleMorning,
            onTapTime: _pickMorningTime,
            accent: widget.accent,
          ),
          const SizedBox(height: 10),
          ReminderRow(
            label: widget.l10n.notificationsEveningLabel,
            time: _eveningTime,
            enabled: _eveningEnabled,
            onToggle: _toggleEvening,
            onTapTime: _pickEveningTime,
            accent: widget.accent,
          ),
          if (Platform.isAndroid &&
              !_batteryOptIgnored &&
              (_morningEnabled || _eveningEnabled)) ...[
            const SizedBox(height: 14),
            BatteryHelperCard(
              title: widget.l10n.notificationsBatteryHelperTitle,
              body: widget.l10n.notificationsBatteryHelperBody,
              action: widget.l10n.notificationsBatteryHelperAction,
              oemHint: widget.l10n.notificationsBatteryHelperOemHint,
              onAction: _requestBatteryOptOut,
            ),
          ],
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Page-position dot indicator

class _DotIndicator extends StatelessWidget {
  final int count;
  final int index;
  final Color activeColor;
  final Color mutedColor;
  const _DotIndicator({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index ? activeColor : mutedColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}
