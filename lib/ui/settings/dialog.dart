import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:flutter/material.dart';

final _prefs = SettingsSharedPreferences();

void showFontSizeDialog(
  BuildContext context,
  double fontSize,
  Function(double) onFontSizeUpdated,
) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.fontSize),
      content: StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.sampleText, style: TextStyle(fontSize: fontSize)),
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
          child: Text(l10n.ok),
          onPressed: () {
            Future.microtask(() {
              _prefs.saveFontSize(fontSize);
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

/// Locale picker. Reads available locales from the SQLite `locales` table at
/// open time, so adding a new locale later is a data-only change.
///
/// On selection: persists the choice, calls [onLocaleChanged] with the new
/// code, dismisses the dialog, then pops back to the root route so any
/// already-pushed screens are rebuilt with the new locale.
void showLocaleDialog(
  BuildContext context,
  String currentLocaleCode,
  Function(String) onLocaleChanged,
) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.language),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        content: SizedBox(
          width: double.maxFinite,
          child: FutureBuilder<List<AppLocale>>(
            future: ZikrRepository().loadLocales(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final locales = snapshot.data ?? const <AppLocale>[];
              return RadioGroup<String>(
                groupValue: currentLocaleCode,
                onChanged: (code) {
                  if (code == null) return;
                  _onLocaleSelected(dialogContext, code, onLocaleChanged);
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: locales.length,
                  itemBuilder: (context, index) {
                    final locale = locales[index];
                    return RadioListTile<String>(
                      title: Text(locale.name),
                      value: locale.code,
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
        ],
      );
    },
  );
}

Future<void> _onLocaleSelected(
  BuildContext dialogContext,
  String code,
  Function(String) onLocaleChanged,
) async {
  await _prefs.saveLocale(code);
  if (!dialogContext.mounted) return;
  onLocaleChanged(code);
  Navigator.pop(dialogContext);
  Navigator.of(dialogContext).popUntil((route) => route.isFirst);
}
