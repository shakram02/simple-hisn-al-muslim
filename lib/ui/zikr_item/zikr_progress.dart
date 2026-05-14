import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/arabic_numbers.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

class ZikrProgress extends StatelessWidget {
  final int count;
  final int maxCount;
  final bool isCompleted;
  final double fontSize;

  const ZikrProgress({
    super.key,
    required this.count,
    required this.maxCount,
    required this.isCompleted,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = count == maxCount;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final current = localizedNumber(count, locale);
    final total = localizedNumber(maxCount, locale);
    final label = isDone ? l10n.done : l10n.pageCounter(current, total);

    final colors = AppColors.of(context);

    return Column(
      children: [
        Text(
          label,
          // Done state: gold. Reserved for completion moments — gives
          // the "X of Y" → "done ✓" transition its gilt-manuscript
          // emotional payoff.
          style: TextStyle(
            color: isDone ? colors.secondary : colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: count / maxCount,
          backgroundColor: AppTheme.mutedColor.shade300,
          // Primary (teal) for the in-progress fill — gold is only
          // earned at completion, not gradually approached.
          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
        ),
      ],
    );
  }
}
