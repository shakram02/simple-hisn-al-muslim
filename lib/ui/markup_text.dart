import 'package:azkar/constants.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

/// Renders content text that may contain inline markup tags from the schema:
///   `<quran>…</quran>`  Quranic verses (rendered in the Uthmanic font, slightly upsized)
///   `<count>…</count>`  repetition phrases (italic, muted)
///   `<note>…</note>`    parenthetical asides (smaller, muted)
///
/// Unknown tags pass through as plain text so the renderer is forward-compatible.
///
/// **Paragraph breaks (`\n\n`):** the markup migrations (009/011/012) insert
/// blank-line separators between semantic units (e.g. between the basmala-and-
/// surah triplet in items 70/76/99, between travel and return duas in 207).
/// Flutter's Text widget DOES render `\n\n` — it produces a single empty line
/// — but on dense Arabic text with default line-height that reads as "just
/// another wrap", not as a paragraph boundary. We split on `\n\n` and render
/// each paragraph as its own [Text.rich] inside a [Column] with a deliberate
/// vertical gap, so the break visibly separates the surahs/units.
///
/// The regex split is done once in [initState] / [didUpdateWidget] (only when
/// `markup` actually changes) — building TextSpans on every frame would
/// otherwise re-scan a 1000+ char string each rebuild.
class MarkupText extends StatefulWidget {
  final String markup;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;

  const MarkupText(this.markup, {super.key, this.baseStyle, this.textAlign});

  @override
  State<MarkupText> createState() => _MarkupTextState();
}

class _MarkupTextState extends State<MarkupText> {
  static final _tagRe = RegExp(r'<(quran|count|note)>(.*?)</\1>', dotAll: true);

  // List of paragraphs, each a list of styled segments.
  late List<List<_Segment>> _paragraphs;

  @override
  void initState() {
    super.initState();
    _paragraphs = _parse(widget.markup);
  }

  @override
  void didUpdateWidget(MarkupText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.markup != widget.markup) {
      _paragraphs = _parse(widget.markup);
    }
  }

  static List<List<_Segment>> _parse(String markup) {
    // Split paragraphs FIRST on \n\n (safe — verified at build time
    // that no tag's body contains \n\n), THEN split each paragraph at
    // <quran> boundaries so Quranic content always renders on its own
    // line, even if it appears mid-narrative. Both splits feed into a
    // single flat list of "paragraphs" rendered as Column rows.
    final result = <List<_Segment>>[];
    for (final paragraph in markup.split('\n\n')) {
      _splitAtQuranBoundaries(paragraph, result);
    }
    return result;
  }

  /// Walks `text` and emits paragraphs into `out`:
  ///   - text BEFORE a `<quran>` tag becomes one paragraph (if it has letters)
  ///   - the `<quran>` tag's body becomes its own paragraph
  ///   - text AFTER the last `<quran>` tag becomes its own paragraph (letters)
  /// Pure-punctuation fragments (e.g. a trailing "." after `</quran>`) are
  /// dropped so they don't render as a lonely period paragraph.
  static void _splitAtQuranBoundaries(String text, List<List<_Segment>> out) {
    final quranOnlyRe = RegExp(r'<quran>(.*?)</quran>', dotAll: true);
    var cursor = 0;
    for (final m in quranOnlyRe.allMatches(text)) {
      if (m.start > cursor) {
        _emitNonQuranPart(text.substring(cursor, m.start), out);
      }
      // The <quran> body becomes a single-segment quran paragraph.
      out.add(<_Segment>[_Segment(m.group(1)!, 'quran')]);
      cursor = m.end;
    }
    if (cursor < text.length) {
      _emitNonQuranPart(text.substring(cursor), out);
    }
  }

  static void _emitNonQuranPart(String text, List<List<_Segment>> out) {
    final stripped = text.trim();
    if (stripped.isEmpty) return;
    if (!_hasLetter(stripped)) return;
    out.add(_splitTags(stripped));
  }

  /// Returns true if [s] contains at least one letter-class codepoint.
  /// Used to filter out pure-punctuation fragments left over after
  /// splitting on tag boundaries. Covers the script ranges this app
  /// renders (Arabic, Latin, Devanagari, Bengali, CJK, Cyrillic, Thai).
  static bool _hasLetter(String s) {
    for (final r in s.runes) {
      if ((r >= 0x0041 && r <= 0x005A) || // Latin upper
          (r >= 0x0061 && r <= 0x007A) || // Latin lower
          (r >= 0x00C0 && r <= 0x024F) || // Latin extended
          (r >= 0x0400 && r <= 0x04FF) || // Cyrillic
          (r >= 0x0600 && r <= 0x06FF) || // Arabic
          (r >= 0x0750 && r <= 0x077F) || // Arabic Supplement
          (r >= 0x0900 && r <= 0x097F) || // Devanagari
          (r >= 0x0980 && r <= 0x09FF) || // Bengali
          (r >= 0x0E00 && r <= 0x0E7F) || // Thai
          (r >= 0x3040 && r <= 0x309F) || // Hiragana
          (r >= 0x30A0 && r <= 0x30FF) || // Katakana
          (r >= 0x3400 && r <= 0x4DBF) || // CJK Extension A
          (r >= 0x4E00 && r <= 0x9FFF) || // CJK Unified
          (r >= 0xAC00 && r <= 0xD7AF)) { // Hangul
        return true;
      }
    }
    return false;
  }

  static List<_Segment> _splitTags(String text) {
    final segments = <_Segment>[];
    var cursor = 0;
    for (final match in _tagRe.allMatches(text)) {
      if (match.start > cursor) {
        segments.add(_Segment(text.substring(cursor, match.start), null));
      }
      segments.add(_Segment(match.group(2)!, match.group(1)));
      cursor = match.end;
    }
    if (cursor < text.length) {
      segments.add(_Segment(text.substring(cursor), null));
    }
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseStyle ?? DefaultTextStyle.of(context).style;
    final colors = AppColors.of(context);

    // Single paragraph: skip the Column wrapping entirely.
    if (_paragraphs.length == 1) {
      return _paragraphRich(_paragraphs[0], base, colors);
    }

    // Gap scales with font size so larger text gets proportionally larger
    // paragraph spacing — at the default fontSize of 20 this is 14px.
    final gap = (base.fontSize ?? AppTheme.fontSize) * 0.7;
    final children = <Widget>[];
    for (var i = 0; i < _paragraphs.length; i++) {
      if (i > 0) children.add(SizedBox(height: gap));
      children.add(_paragraphRich(_paragraphs[i], base, colors));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _paragraphRich(
    List<_Segment> segments,
    TextStyle base,
    AppColors colors,
  ) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          for (final s in segments)
            TextSpan(
              text: s.text,
              style: s.tag == null ? base : _styleFor(s.tag!, base, colors),
            ),
        ],
      ),
      textAlign: widget.textAlign,
    );
  }

  TextStyle _styleFor(String tag, TextStyle base, AppColors colors) {
    switch (tag) {
      case 'quran':
        return base.copyWith(
          fontFamily: AppTheme.quranFontFamily,
          fontSize: (base.fontSize ?? AppTheme.fontSize) * 1.1,
        );
      case 'count':
        // Slightly lighter than `note` — italicized to read as a count
        // annotation rather than body prose.
        return base.copyWith(
          fontStyle: FontStyle.italic,
          fontSize: (base.fontSize ?? AppTheme.fontSize) * 0.85,
          color: colors.textTertiary,
        );
      case 'note':
        // Slightly darker than `count` — these are parenthetical asides
        // and should read at near-secondary contrast.
        return base.copyWith(
          fontSize: (base.fontSize ?? AppTheme.fontSize) * 0.85,
          color: colors.textSecondary,
        );
      default:
        return base;
    }
  }
}

class _Segment {
  final String text;
  final String? tag;
  const _Segment(this.text, this.tag);
}
