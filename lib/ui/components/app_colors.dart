import 'package:flutter/material.dart';

/// Semantic, brightness-aware color palette exposed as a `ThemeExtension`.
///
/// Callers read colors by their *role* (e.g. `textPrimary`,
/// `textSecondary`, `secondary`) rather than re-deriving a light vs dark
/// branch at each call site. This pushes the light/dark decision down
/// into `ThemeData.extensions`, keeping widget code uncluttered.
///
/// Usage:
///
/// ```dart
/// final colors = AppColors.of(context);
/// Text('Hello', style: TextStyle(color: colors.textPrimary));
/// ```
///
/// Concrete light/dark instances live next to the rest of the palette in
/// `constants.dart` (`AppTheme.lightColors` / `AppTheme.darkColors`) and
/// are registered on `ThemeData(extensions: [...])` once at theme build
/// time — see `AppTheme.lightTheme` / `AppTheme.darkTheme`.
class AppColors extends ThemeExtension<AppColors> {
  // ── Surfaces ──────────────────────────────────────────────────

  /// Scaffold / drawer background fill.
  final Color background;

  /// Card surface fill (sits *on* `background`, lighter than it).
  final Color surface;

  /// Standard card shadow (used by `SoftCard`).
  final List<BoxShadow> cardShadow;

  /// Higher-elevation shadow — for selected, hovered, or completion
  /// states. Heavier blur, slightly darker. Use sparingly; the default
  /// `cardShadow` is the right answer 95% of the time.
  final List<BoxShadow> cardShadowElevated;

  /// 1-px separator color. Used by `Divider`-equivalents inside cards
  /// or between list sections.
  final Color divider;

  // ── Text — 3 contrast tiers ──────────────────────────────────
  //
  // Three tiers, ordered most → least prominent:
  //   textPrimary > textSecondary > textTertiary
  //
  // An earlier draft had 5 tiers and one of them (`textSofter`) was
  // misnamed — the value was actually *darker* than `textSecondary`.
  // Three tiers is enough for our hierarchy; if you reach for a fourth,
  // use `iconMuted` or `caption` which are not text tiers.

  /// Title / primary copy. Highest contrast against `surface`.
  final Color textPrimary;

  /// Subtitle / secondary copy.
  final Color textSecondary;

  /// Faint text — captions, transliteration, deep-muted body. Lowest
  /// readable contrast tier.
  final Color textTertiary;

  // ── Icons ────────────────────────────────────────────────────

  /// Inactive icons (search prefix, inactive heart, idle progress).
  /// Lower contrast than any text tier.
  final Color iconMuted;

  // ── Tinted backgrounds ──────────────────────────────────────

  /// The standard "accent tint" backdrop used by callout cards
  /// (battery-helper, drawer header icon block, onboarding accent
  /// affordances). Computed once per theme so the alpha math
  /// (10% on light surfaces, 18% on dark) doesn't keep getting
  /// re-derived at every call site.
  final Color accentTintBg;

  // ── Brand ──────────────────────────────────────────────────

  /// Primary brand color (deepened teal). Light mode uses shade600,
  /// dark mode uses shade300. Use for prominent affordances —
  /// audio controls, progress bars, drawer header, primary CTAs.
  final Color primary;

  /// Secondary brand color (warm gold). Use sparingly and reserve it
  /// for *completion* moments — the gilt-manuscript reference. If
  /// everything is gold, nothing is.
  final Color secondary;

  const AppColors({
    required this.background,
    required this.surface,
    required this.cardShadow,
    required this.cardShadowElevated,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconMuted,
    required this.accentTintBg,
    required this.primary,
    required this.secondary,
  });

  /// Pulls the extension off the active theme. Throws if no extension is
  /// registered — that's intentional: we register on both light AND dark
  /// themes, so a missing extension means a misconfigured `ThemeData`.
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? cardShadowElevated,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? iconMuted,
    Color? accentTintBg,
    Color? primary,
    Color? secondary,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardShadow: cardShadow ?? this.cardShadow,
      cardShadowElevated: cardShadowElevated ?? this.cardShadowElevated,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      iconMuted: iconMuted ?? this.iconMuted,
      accentTintBg: accentTintBg ?? this.accentTintBg,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      // BoxShadow.lerpList handles list-length mismatches by interpolating
      // toward an empty list — fine for our small fixed-length shadows.
      cardShadow:
          BoxShadow.lerpList(cardShadow, other.cardShadow, t) ?? cardShadow,
      cardShadowElevated:
          BoxShadow.lerpList(cardShadowElevated, other.cardShadowElevated, t) ??
              cardShadowElevated,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      accentTintBg: Color.lerp(accentTintBg, other.accentTintBg, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }
}
