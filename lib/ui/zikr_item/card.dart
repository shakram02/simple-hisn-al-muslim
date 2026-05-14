import 'package:azkar/constants.dart';
import 'package:azkar/model.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/components/soft_card.dart';
import 'package:azkar/ui/markup_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZikrItemCard extends StatefulWidget {
  final ZikrItem zikr;
  final String localeCode;
  final double fontSize;
  final int currentCount;
  final Function(int) onCountChanged;
  final VoidCallback onCompleted;

  const ZikrItemCard({
    super.key,
    required this.zikr,
    required this.localeCode,
    required this.fontSize,
    required this.currentCount,
    required this.onCountChanged,
    required this.onCompleted,
  });

  @override
  State<ZikrItemCard> createState() => _ZikrItemCardState();
}

class _ZikrItemCardState extends State<ZikrItemCard> {
  bool _isPressed = false;

  bool get _isArabicLocale => widget.localeCode == 'ar';
  // Arabic prayer is ALWAYS RTL inside its own Directionality, regardless
  // of locale. Translation direction follows the *content* locale (not the
  // chrome fallback) — e.g. Persian translations need RTL too.
  TextDirection get _translationDirection =>
      Constants.rtlLocaleCodes.contains(widget.localeCode)
          ? TextDirection.rtl
          : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates the card to its own layer so the engine
    // can translate the existing layer during PageView transitions
    // instead of repainting the shadow + content on every animation
    // frame. Big win when two cards are on screen mid-slide.
    return RepaintBoundary(
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SoftCard(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          // GestureDetector instead of SoftCard's onTap — no ripple,
          // but the tap-scale + counter increment together are the
          // visual feedback. Skipping the ripple's per-tap shader work
          // matters because users tap rapidly through repeat counts.
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const double _duplicateThreshold = 0.8;
  static final _tagStripRe = RegExp(r'<[^>]+>');
  // `\w+` (unicode) covers Latin letters, digits, underscores, plus
  // composed letters from other scripts — sufficient for tokenizing
  // romanized Arabic + locale translations into comparable word bags.
  static final _wordRe = RegExp(r'\w+', unicode: true);

  // `<quran>…</quran>` blocks wrap Quranic verses in the markup.
  // `dotAll: true` so the regex matches across newlines.
  static final _quranBlockRe = RegExp(r'<quran>.*?</quran>', dotAll: true);
  // Metadata tags (count repetitions, narrator notes) — these describe
  // *how* to recite, not the content being recited, so we strip them
  // before computing the Quran-vs-prose ratio below.
  static final _metaBlockRe = RegExp(
    r'<(?:count|note)>.*?</(?:count|note)>',
    dotAll: true,
  );
  // Quran-dominant threshold: how much of the recitable markup must
  // sit inside `<quran>` tags for the item to count as "Quran-only".
  // Surah-title preambles ("سُورَةُ الْفَلَقِ", ~15 chars) before a
  // 100+ char verse block clear 0.85 easily; items with substantial
  // dua/instruction prose mixed alongside the verse do not.
  static const double _quranDominantThreshold = 0.85;

  /// Returns true when the item's recitable content is essentially a
  /// Quranic verse (or set of verses) with at most a short heading.
  /// Used to keep the Arabic block visually primary even on non-Arabic
  /// locales — Quranic content has different religious status than
  /// prose duas (the verse *is* the divine speech, not a paraphrase),
  /// so we mirror standard Quran-translation layout: Arabic on top,
  /// transliteration / translation as reference below.
  bool get _isQuranOnly {
    final markup = widget.zikr.arabicMarkup;
    if (markup.isEmpty) return false;
    if (!_quranBlockRe.hasMatch(markup)) return false;
    final withoutMeta = markup.replaceAll(_metaBlockRe, '');
    var quranChars = 0;
    for (final m in _quranBlockRe.allMatches(withoutMeta)) {
      quranChars += m.group(0)!.length;
    }
    if (withoutMeta.isEmpty) return false;
    return quranChars / withoutMeta.length >= _quranDominantThreshold;
  }

  /// Returns true when the translation is mostly the same word-bag as
  /// the transliteration. Jaccard similarity on lowercased token sets
  /// — agnostic to punctuation, smart-vs-straight quotes, narrator
  /// honorific glyphs ("t"/"r"), and minor word reorderings.
  bool _isLargelyDuplicate(String translation, String? transliteration) {
    if (transliteration == null) return false;
    final trimmedTr = transliteration.trim();
    if (trimmedTr.isEmpty) return false;
    final stripped = translation.replaceAll(_tagStripRe, '');
    final a = _tokenSet(trimmedTr);
    final b = _tokenSet(stripped);
    if (a.isEmpty || b.isEmpty) return false;
    final inter = a.intersection(b).length;
    final union = a.length + b.length - inter;
    return union > 0 && inter / union >= _duplicateThreshold;
  }

  Set<String> _tokenSet(String text) {
    return _wordRe
        .allMatches(text.toLowerCase())
        .map((m) => m.group(0)!)
        .toSet();
  }

  void _handleTap() {
    if (widget.currentCount >= widget.zikr.repeatCount) return;
    final next = widget.currentCount + 1;
    widget.onCountChanged(next);
    if (next == widget.zikr.repeatCount) {
      HapticFeedback.mediumImpact();
      widget.onCompleted();
    }
  }

  List<Widget> _buildContent(BuildContext context) {
    final widgets = <Widget>[];
    final mutedColor = AppColors.of(context).textTertiary;

    final transliteration = widget.zikr.transliteration;
    final translation = widget.zikr.translation;
    final footnote = widget.zikr.footnote;

    final hasTransliteration = !_isArabicLocale &&
        transliteration != null &&
        transliteration.trim().isNotEmpty;
    final translationIsMeaningful = !_isArabicLocale &&
        translation != null &&
        translation.trim().isNotEmpty &&
        // Hide the translation block when it largely duplicates the
        // transliteration text — ~220 `en` items ship the romanized
        // Arabic in both fields, differing only on quotes/punctuation/
        // narrator-suffix glyphs. The transliteration's italic-muted
        // styling already communicates "this is a romanization", so
        // rendering the same word-set a second time at heavier weight
        // adds noise, not information.
        !_isLargelyDuplicate(translation, transliteration);

    // The Arabic block — always shown, RTL, at the locale's `fontSize`.
    Widget arabicBlock() => Directionality(
          textDirection: TextDirection.rtl,
          child: MarkupText(
            widget.zikr.arabicMarkup,
            baseStyle: TextStyle(fontSize: widget.fontSize),
            textAlign: TextAlign.center,
          ),
        );

    // Two visual treatments depending on which block leads the card:
    //
    //   - When Arabic leads (Arabic locale OR Quran-only on a non-
    //     Arabic locale), transliteration is *reference* — small,
    //     italic, muted; translation is the meaning-carrier just under
    //     the verse — slightly larger, regular weight.
    //
    //   - When transliteration leads (non-Arabic locale, prose dua),
    //     the styles invert. The transliteration becomes the body text
    //     a reciter reads off, so it gets the larger size + regular
    //     weight + default color. The translation drops to the
    //     small/italic/muted treatment — explanatory note style.
    Widget transliterationAsReference() => Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            transliteration!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize * 0.85,
              fontStyle: FontStyle.italic,
              color: mutedColor,
            ),
          ),
        );
    Widget transliterationAsLead() => Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            transliteration!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: widget.fontSize * 0.9),
          ),
        );
    Widget translationAsBody() => Directionality(
          textDirection: _translationDirection,
          child: MarkupText(
            translation!,
            baseStyle: TextStyle(fontSize: widget.fontSize * 0.9),
            textAlign: TextAlign.center,
          ),
        );
    Widget translationAsNote() => Directionality(
          textDirection: _translationDirection,
          child: MarkupText(
            translation!,
            baseStyle: TextStyle(
              fontSize: widget.fontSize * 0.85,
              fontStyle: FontStyle.italic,
              color: mutedColor,
            ),
            textAlign: TextAlign.center,
          ),
        );

    if (_isArabicLocale) {
      // Arabic locale: the Arabic markup IS the content. Transliteration
      // and translation are suppressed (they'd be a romanization of the
      // very text being shown, and a translation into Arabic of an Arabic
      // dua respectively — both noise).
      widgets.add(arabicBlock());
    } else if (_isQuranOnly) {
      // Quranic content gets Arabic-first layout even on non-Arabic
      // locales. The verse IS the divine speech, not a paraphrase —
      // mirrors how published Quran translations print (Arabic recto,
      // translation verso). Transliteration sits below as reference
      // (small/italic/muted); translation reads as normal body copy.
      widgets.add(arabicBlock());
      if (hasTransliteration) {
        widgets.add(const SizedBox(height: 18));
        widgets.add(transliterationAsReference());
      }
      if (translationIsMeaningful) {
        widgets.add(const SizedBox(height: 22));
        widgets.add(translationAsBody());
      }
    } else {
      // Non-Arabic locale, prose-dua item: lead with the operational
      // text. For a reader who can't read Arabic, the transliteration
      // is what their eyes are on while reciting — that's the primary
      // content (rendered as body text, easy to read). The translation
      // drops to italic/muted/smaller — it's the explanatory note. The
      // Arabic anchors the canonical form at the bottom of the card.
      // This avoids forcing every non-Arabic user to scroll past the
      // large Arabic block on every single item to find the
      // transliteration / translation.
      if (hasTransliteration) {
        widgets.add(transliterationAsLead());
      }
      if (translationIsMeaningful) {
        if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 18));
        widgets.add(translationAsNote());
      }
      // Slightly larger gap (22) before the Arabic block — visually
      // signals "now the canonical form" rather than continuation.
      if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 22));
      widgets.add(arabicBlock());
    }

    if (footnote != null && footnote.trim().isNotEmpty) {
      widgets.add(const SizedBox(height: 20));
      widgets.add(
        Directionality(
          textDirection: _isArabicLocale
              ? TextDirection.rtl
              : _translationDirection,
          child: Text(
            footnote,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: widget.fontSize * 0.72, color: mutedColor),
          ),
        ),
      );
    }

    return widgets;
  }
}
