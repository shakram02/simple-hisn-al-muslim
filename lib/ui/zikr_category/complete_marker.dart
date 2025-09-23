import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';

class ZikrItemCompleteMarker extends StatelessWidget {
  const ZikrItemCompleteMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'تم ✓',
      style: TextStyle(
        fontSize: AppTheme.noteFontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkSecondary
            : AppTheme.secondaryColor,
      ),
    );
  }
}
