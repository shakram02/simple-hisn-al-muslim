import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';

class ZikrAppBar {
  static AppBar getAppBar({
    required String title,
    required BuildContext context,
    required VoidCallback onFontSizeChangeButtonPressed,
    required VoidCallback onThemeToggle,
  }) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.primaryColor.shade900
          : AppTheme.primaryColor.shade700,
      foregroundColor: AppTheme.whiteColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.text_fields),
          onPressed: onFontSizeChangeButtonPressed,
        ),
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: onThemeToggle,
        ),
      ],
    );
  }
}
