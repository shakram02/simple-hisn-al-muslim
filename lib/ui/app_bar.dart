import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

/// Standard AppBar for category list + zikr detail screens.
///
/// Surface uses the screen background (cream in light, near-black in
/// dark) with a neutral ink title — no teal block on top of the page.
/// Title uses a medium weight (not bold) and supports 2 lines so long
/// category titles in any locale don't get ellipsed at 56dp.
///
/// The Scaffold MUST provide `drawer: AzkarDrawer(...)` — Flutter then
/// auto-injects a hamburger as the leading icon, so this widget defines
/// no actions.
class ZikrAppBar {
  static AppBar getAppBar({
    required String title,
    required BuildContext context,
  }) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // titleMedium is the chrome's app-bar slot — Vazirmatn 17/600.
        style: theme.textTheme.titleMedium?.copyWith(height: 1.2),
      ),
      centerTitle: true,
      toolbarHeight: 64,
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}
