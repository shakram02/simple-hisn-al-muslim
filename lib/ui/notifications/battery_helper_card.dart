import 'package:azkar/constants.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

/// Surface card that explains the OS battery-optimization issue and offers
/// a single-tap action to request whitelist status. Shared between the
/// dedicated notifications-settings screen and the onboarding reminder
/// slide so both UIs render the same affordance.
///
/// Render only when:
///   - `Platform.isAndroid` (iOS has no equivalent permission), AND
///   - at least one reminder is enabled, AND
///   - the app is NOT yet on the battery-optimization whitelist.
///
/// Caller owns the conditional gate — this widget always renders if mounted.
class BatteryHelperCard extends StatelessWidget {
  final String title;
  final String body;
  final String action;
  final String oemHint;
  final VoidCallback onAction;

  const BatteryHelperCard({
    super.key,
    required this.title,
    required this.body,
    required this.action,
    required this.oemHint,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final accent = colors.primary;
    final bodyColor = colors.textTertiary;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: colors.accentTintBg,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.battery_charging_full_rounded, color: accent, size: 20),
              const SizedBox(width: 10),
              Text(title, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(color: bodyColor),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: accent,
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
              ),
              child: Text(
                action,
                style: theme.textTheme.titleSmall?.copyWith(color: accent),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            oemHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: bodyColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
