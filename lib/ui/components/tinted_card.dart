import 'package:azkar/constants.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

/// Sibling to `SoftCard` for affordances that need a soft accent
/// gradient on top of the standard surface. Used by the home-screen
/// share/rate CTA pair, and (sparingly) by other surfaces that want to
/// say "this is a special action, not a row in a list".
///
/// Inherits SoftCard's shadow + radius + dark-aware surface. Adds a
/// gradient overlay computed from the [tint] color — drawn corner to
/// corner, fading from full strength at top-left to ~40% at
/// bottom-right.
///
/// **Don't reach for this for every interactive card.** Tinted cards
/// stop being special when there are five of them on screen. The CTA
/// pair (two cards) and one-offs (e.g. drawer header affordances) is
/// the right cadence.
class TintedCard extends StatelessWidget {
  final Color tint;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Widget child;

  const TintedCard({
    super.key,
    required this.tint,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(12, 12, 12, 12),
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              boxShadow: colors.cardShadow,
              // Gradient layer over the base surface — gives the card
              // accent character without an outline. Alpha decay
              // (full → 40%) creates the soft diagonal "wash".
              gradient: LinearGradient(
                colors: [tint, tint.withValues(alpha: tint.a * 0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
