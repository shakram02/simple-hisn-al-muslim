import 'package:azkar/constants.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';

final fontSharedPreferences = SettingsSharedPreferences();

void showFontSizeDialog(
  BuildContext context,
  double fontSize,
  Function(double) onFontSizeUpdated,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('حجم الخط'),
      content: StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('مثال للنص', style: TextStyle(fontSize: fontSize)),
              const SizedBox(height: 20),
              Slider(
                value: fontSize,
                min: 18,
                max: AppTheme.fontSize * 2,
                divisions: 10,
                label: fontSize.round().toString(),
                onChanged: (value) {
                  setDialogState(() {
                    fontSize = value;
                  });

                  onFontSizeUpdated(fontSize);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('موافق'),
          onPressed: () {
            Future.microtask(() {
              fontSharedPreferences.saveFontSize(fontSize);
              debugPrint('fontSize saved: $fontSize');
            });
            onFontSizeUpdated(fontSize);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
