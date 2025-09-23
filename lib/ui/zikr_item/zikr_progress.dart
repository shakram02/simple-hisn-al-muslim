import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';
import 'package:azkar/ui/arabic_numbers.dart';

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
    final isCompleted = count == maxCount;
    final arabicCount = arabicNumber(count);
    final arabicMaxCount = arabicNumber(maxCount);

    return Column(
      children: [
        Text(
          isCompleted ? 'تم ✓' : '$arabicCount من $arabicMaxCount',
          style: TextStyle(
            // fontSize: fontSize - 2,
            // fontWeight: FontWeight.bold,
            color: isCompleted
                ? AppTheme.secondaryColor
                : Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkTextSecondary
                : AppTheme.mutedColor.shade700,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: count / maxCount,
          backgroundColor: AppTheme.mutedColor.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkSecondary
                : AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }
}
