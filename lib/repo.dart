import 'dart:io';

import 'package:azkar/constants.dart';
import 'package:azkar/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ZikrRepository {
  static final ZikrRepository _instance = ZikrRepository._internal();
  factory ZikrRepository() => _instance;
  ZikrRepository._internal();

  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, Constants.databaseFileName);

    await _deleteLegacyDatabases(dbDir);

    if (await _needsCopy(dbPath)) {
      await _copyAssetTo(dbPath);
    }

    return openDatabase(dbPath, readOnly: true);
  }

  Future<void> _deleteLegacyDatabases(String dbDir) async {
    for (final name in Constants.legacyDatabaseFileNames) {
      final file = File(join(dbDir, name));
      if (!await file.exists()) continue;
      try {
        await file.delete();
      } catch (e) {
        debugPrint('repo: failed to delete legacy db $name: $e');
      }
    }
  }

  Future<bool> _needsCopy(String dbPath) async {
    final file = File(dbPath);
    if (!await file.exists()) return true;

    try {
      final probe = await openDatabase(dbPath, readOnly: true);
      try {
        final rows = await probe.rawQuery('PRAGMA user_version');
        final version = (rows.first.values.first as int?) ?? 0;
        return version < Constants.expectedSchemaVersion;
      } finally {
        await probe.close();
      }
    } catch (e) {
      debugPrint('repo: failed to read schema version, will replace: $e');
      return true;
    }
  }

  Future<void> _copyAssetTo(String dbPath) async {
    final file = File(dbPath);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (e) {
        debugPrint('repo: failed to delete stale db before copy: $e');
      }
    }
    final data = await rootBundle.load(Constants.databaseAssetPath);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<List<AppLocale>> loadLocales() async {
    final db = await database;
    final rows = await db.query('locales', orderBy: 'code');
    return rows
        .map(
          (r) => AppLocale(
            code: r['code'] as String,
            name: r['name'] as String,
            direction: r['direction'] as String,
          ),
        )
        .toList();
  }

  Future<List<ZikrCategory>> loadCategories(String localeCode) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT c.id, c.display_order, ct.title
      FROM categories c
      JOIN category_titles ct
        ON ct.category_id = c.id AND ct.locale_code = ?
      ORDER BY c.display_order
    ''',
      [localeCode],
    );

    return rows
        .map(
          (r) => ZikrCategory(
            id: r['id'] as int,
            title: r['title'] as String,
            displayOrder: r['display_order'] as int,
          ),
        )
        .toList();
  }

  Future<List<ZikrItem>> loadCategoryItems(
    int categoryId,
    String localeCode,
  ) async {
    final db = await database;
    final isArabic = localeCode == 'ar';

    final rows = await db.rawQuery(
      '''
      SELECT
        i.id, i.category_id, i.item_order, i.repeat_count,
        i.audio_url, i.transliteration,
        ar.markup AS arabic_markup,
        tr.markup AS translation_markup,
        tr.footnote AS translation_footnote
      FROM items i
      JOIN item_translations ar
        ON ar.item_id = i.id AND ar.locale_code = 'ar'
      LEFT JOIN item_translations tr
        ON tr.item_id = i.id AND tr.locale_code = ?
      WHERE i.category_id = ?
      ORDER BY i.item_order
    ''',
      [localeCode, categoryId],
    );

    return rows.map((r) {
      return ZikrItem(
        id: r['id'] as int,
        categoryId: r['category_id'] as int,
        order: r['item_order'] as int,
        repeatCount: r['repeat_count'] as int,
        audioUrl: r['audio_url'] as String?,
        transliteration: r['transliteration'] as String?,
        arabicMarkup: r['arabic_markup'] as String,
        translation: isArabic ? null : r['translation_markup'] as String?,
        footnote: r['translation_footnote'] as String?,
      );
    }).toList();
  }

  static final RegExp _searchTagStripRe = RegExp(r'<[^>]+>');

  /// Mirror of build_sqlite.normalize_for_search and migration
  /// 019_rebuild_search_text_v2.py. ALL THREE MUST STAY IN SYNC. Strips
  /// markup tags, folds Arabic letter variants (incl. Mushaf forms like
  /// wasla alef ٱ → ا), strips combining marks (harakat, dagger alef ٰ,
  /// small waw ۥ, Latin accents, etc.), and lower-cases.
  static String normalizeForSearch(String text) {
    if (text.isEmpty) return '';
    // Strip markup tags first (so their chars don't leak in).
    text = text.replaceAll(_searchTagStripRe, '');
    final buf = StringBuffer();
    for (final rune in text.runes) {
      // Arabic letter folds — collapse equivalent shapes to a single
      // canonical form. Must match _SEARCH_ARABIC_FOLD on the Python
      // side. We do this inline (per rune) rather than via a Map<int,int>
      // lookup because the fold table is small (~8 entries).
      int r = rune;
      switch (r) {
        case 0x0623: // أ
        case 0x0625: // إ
        case 0x0622: // آ
        case 0x0671: // ٱ wasla
          r = 0x0627; // → ا
          break;
        case 0x0649: // ى alef maksura
          r = 0x064A; // → ي
          break;
        case 0x0629: // ة teh marbuta
          r = 0x0647; // → ه
          break;
        case 0x0624: // ؤ
          r = 0x0648; // → و
          break;
        case 0x0626: // ئ
          r = 0x064A; // → ي
          break;
        case 0x0640: // ـ tatweel — drop entirely
          continue;
      }
      // Combining-mark ranges to drop. Equivalent to NFKD + filter
      // category=='Mn' on the Python side.
      //   U+0300–U+036F  general combining diacriticals
      //   U+0483–U+0489  Cyrillic combining
      //   U+064B–U+065F  Arabic harakat
      //   U+0670        Arabic superscript alef (dagger alef)
      //   U+06D6–U+06ED  Quranic annotation marks
      //   U+06E5–U+06E6  Arabic small waw / small yeh (Mushaf forms)
      //   U+0711        Syriac superscript alaph
      //   U+0730–U+074A  Syriac points
      final isCombining =
          (r >= 0x0300 && r <= 0x036F) ||
          (r >= 0x0483 && r <= 0x0489) ||
          (r >= 0x064B && r <= 0x065F) ||
          r == 0x0670 ||
          (r >= 0x06D6 && r <= 0x06ED) ||
          (r >= 0x06E5 && r <= 0x06E6) ||
          r == 0x0711 ||
          (r >= 0x0730 && r <= 0x074A);
      if (isCombining) continue;
      buf.writeCharCode(r);
    }
    return buf.toString().toLowerCase();
  }

  Future<List<ZikrSearchResult>> searchItems(
    String localeCode,
    String query, {
    int limit = 30,
  }) async {
    final db = await database;
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    // LIKE-based search against the precomputed `search_text` column —
    // we don't use FTS5 because pre-Android-11 system SQLite lacks the
    // fts5 module. search_text is built diacritic-stripped + lowercased
    // (see build_sqlite.py and migration 013); we normalize the query
    // the same way before substring-matching.
    final needle = normalizeForSearch(trimmed);
    if (needle.isEmpty) return const [];
    // Escape LIKE metacharacters in the user input so a query like
    // "ال_رحمن" doesn't treat "_" as a wildcard. We use an explicit
    // backslash escape clause.
    final escaped = needle
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    final pattern = '%$escaped%';

    // Two ways to qualify: the item body matched OR the category
    // title matched. Both columns are normalized at build time
    // (`search_text` for bodies, `search_title` for category names)
    // and indexed on `(locale_code, *)` so the LIKE scan stays cheap
    // even with the OR. Before search_title existed, queries like
    // "النوم" matched zero rows because the word only appears in the
    // category title "أذكار النوم", never in any verse body.
    final rows = await db.rawQuery(
      r'''
      SELECT it.item_id, i.category_id, ct.title AS category_title,
             it.markup, it.footnote
      FROM item_translations it
      JOIN items i ON i.id = it.item_id
      JOIN category_titles ct
        ON ct.category_id = i.category_id AND ct.locale_code = ?
      WHERE it.locale_code = ?
        AND (
          it.search_text  LIKE ? ESCAPE '\'
          OR ct.search_title LIKE ? ESCAPE '\'
        )
      LIMIT ?
      ''',
      [localeCode, localeCode, pattern, pattern, limit],
    );

    return rows.map((r) {
      final markup = r['markup'] as String? ?? '';
      final footnote = r['footnote'] as String? ?? '';
      final combined = footnote.isNotEmpty ? '$markup\n$footnote' : markup;
      return ZikrSearchResult(
        itemId: r['item_id'] as int,
        categoryId: r['category_id'] as int,
        categoryTitle: r['category_title'] as String,
        snippet: _buildSnippet(combined, needle),
      );
    }).toList();
  }

  /// Builds a ~120-char snippet of [source] centred on the first match of
  /// [needle] (case-insensitively + diacritic-insensitively). If no exact
  /// substring match exists in the visible text (e.g. matched on
  /// diacritic-stripped form only), falls back to the source's head.
  String _buildSnippet(String source, String needle) {
    const window = 60;
    final normalizedSource = normalizeForSearch(source);
    final idx = normalizedSource.indexOf(needle);
    if (idx < 0) {
      // Match was in normalized form only; show head of original.
      return source.length <= window * 2
          ? source
          : '${source.substring(0, window * 2)}…';
    }
    // The normalized index ≈ original index (NFKD strip preserves rune
    // count for the scripts we have here — Arabic combining marks are
    // separate code points, not merged). Use it directly.
    final start = (idx - window).clamp(0, source.length);
    final end = (idx + needle.length + window).clamp(0, source.length);
    final prefix = start > 0 ? '…' : '';
    final suffix = end < source.length ? '…' : '';
    return '$prefix${source.substring(start, end)}$suffix';
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db == null) return;
    await db.close();
    _database = null;
  }
}
