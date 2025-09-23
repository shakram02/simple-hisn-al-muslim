import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';

class ZikrAppBar {
  static AppBar getAppBar(VoidCallback onFontSizeChangeButtonPressed) {
    return AppBar(
      title: const Text(Constants.appName),
      centerTitle: true,
      backgroundColor: AppTheme.primaryColor.shade700,
      foregroundColor: AppTheme.whiteColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.text_fields),
          onPressed: onFontSizeChangeButtonPressed,
        ),
        
      ],
    );
  }
}
