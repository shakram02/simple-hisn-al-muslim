import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/components/soft_card.dart';
import 'package:flutter/material.dart';

/// A single reminder configuration row: label + tap-to-edit time chip on
/// the left column, enable/disable Switch on the right. Used both in the
/// dedicated notifications-settings screen and in the onboarding
/// reminder-setup slide so the two surfaces stay visually identical.
///
/// Pass [accent] if the caller wants to override the default primary
/// shade used for the Switch thumb (e.g. onboarding uses an accent
/// pre-resolved from its slide theme); leave it null and the row resolves
/// the standard light/dark primary shade itself.
class ReminderRow extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTapTime;
  final Color? accent;

  const ReminderRow({
    super.key,
    required this.label,
    required this.time,
    required this.enabled,
    required this.onToggle,
    required this.onTapTime,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final effectiveAccent = accent ?? colors.primary;
    final titleColor = colors.textPrimary;
    final mutedColor = colors.textSecondary;
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(18, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                InkWell(
                  onTap: onTapTime,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: mutedColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          time.format(context),
                          // bodyMedium + tabular figures so the time
                          // chip's digits stay column-aligned across
                          // morning/evening rows.
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: enabled ? titleColor : mutedColor,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeThumbColor: effectiveAccent,
          ),
        ],
      ),
    );
  }
}
