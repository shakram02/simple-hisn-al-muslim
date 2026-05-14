import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/notifications/screen.dart';
import 'package:azkar/ui/settings/dialog.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';

/// Side drawer holding all user preferences flattened into one place.
///
/// In v1.1 we previously split into "drawer quick actions" + "settings
/// screen". With only language behind the screen, a one-entry settings
/// page is more friction than feature; everything lives directly in the
/// drawer until a 2nd less-frequent preference earns the screen back.
class AzkarDrawer extends StatelessWidget {
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final String localeCode;
  final Function(String) onLocaleChanged;

  const AzkarDrawer({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.localeCode,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final accent = colors.primary;
    final titleColor = colors.textPrimary;
    final iconColor = colors.textSecondary;

    return Drawer(
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Quiet header — small accent icon + app title on the same
            // surface as the rest of the drawer. No teal block to fight
            // the cream/dark background.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.accentTintBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.menu_book_rounded, color: accent, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 0.6, color: colors.divider),
            const SizedBox(height: 8),
            SwitchListTile(
              secondary: Icon(
                isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: iconColor,
              ),
              title: Text(
                l10n.settingsTheme,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              activeThumbColor: accent,
              value: isDarkMode,
              onChanged: (_) => onThemeToggle(),
            ),
            _FontSizeQuickAction(
              fontSize: fontSize,
              onFontSizeChanged: onFontSizeChanged,
              label: l10n.fontSize,
              iconColor: iconColor,
              titleColor: titleColor,
              accent: accent,
            ),
            ListTile(
              leading: Icon(Icons.language_rounded, color: iconColor),
              title: Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
                Constants.localeNativeNames[localeCode] ?? localeCode,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
              ),
              onTap: () =>
                  showLocaleDialog(context, localeCode, onLocaleChanged),
            ),
            ListTile(
              leading: Icon(
                Icons.notifications_outlined,
                color: iconColor,
              ),
              title: Text(
                l10n.notificationsScreenTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FontSizeQuickAction extends StatelessWidget {
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final String label;
  final Color iconColor;
  final Color titleColor;
  final Color accent;

  const _FontSizeQuickAction({
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.label,
    required this.iconColor,
    required this.titleColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields_rounded, color: iconColor),
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                fontSize.round().toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: iconColor,
                    ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: accent,
              thumbColor: accent,
              overlayColor: accent.withValues(alpha: 0.12),
            ),
            child: Slider(
              value: fontSize,
              min: 18,
              max: AppTheme.fontSize * 2,
              divisions: 10,
              label: fontSize.round().toString(),
              onChanged: onFontSizeChanged,
              onChangeEnd: (value) {
                onFontSizeChanged(value);
                SettingsSharedPreferences().persistFontSize(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
