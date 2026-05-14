import 'package:azkar/constants.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

/// Standard surface card used across the app: rounded corners, soft
/// theme-aware shadow, surface fill, anti-aliased clipping so any
/// ink-splash from a child stays inside the rounded shape.
///
/// Two modes, picked by whether [onTap] is supplied:
///   - **passive**: just decoration around [child].
///   - **tappable**: decoration + `Material` + `InkWell` with a built-in
///     ripple. Use this instead of hand-wiring those wrappers at each
///     call site.
///
/// For tappable cards where ripple is *unwanted* (e.g. high-frequency
/// counters that would repaint per tap), don't pass [onTap] — wrap the
/// [child] in your own `GestureDetector` instead. SoftCard's
/// `clipBehavior: Clip.antiAlias` keeps your custom hit-testing visually
/// contained.
///
/// Skip SoftCard when the card needs a non-standard surface treatment
/// (gradient overlay, tinted-accent background, no-shadow state).
/// Inline `Container(decoration: ...)` stays the right tool for those
/// one-off variations; adding 6 optional params to SoftCard would turn
/// it into a config language.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      );
    }
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: colors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }
}
