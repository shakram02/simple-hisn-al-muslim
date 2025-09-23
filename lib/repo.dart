import 'package:azkar/constants.dart';
import 'package:azkar/model.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ZikrRepository {
  static final ZikrRepository _instance = ZikrRepository._internal();
  factory ZikrRepository() => _instance;
  ZikrRepository._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the documents directory
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, Constants.databaseName);

    // Check if database exists
    if (!await File(path).exists()) {
      // Copy from assets to documents directory
      final data = await rootBundle.load(Constants.databaseName);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, readOnly: true);
  }

  Future<List<ZikrCategory>> loadIndex(String locale) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'zikr_categories',
      where: 'locale = ?',
      whereArgs: [locale],
    );

    return maps
        .map(
          (map) => ZikrCategory(
            id: map['id'],
            title: map['title'],
            order: map['category_order'],
          ),
        )
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<List<ZikrItem>> loadCategoryZikr(int categoryId) async {
    final db = await database;

    // Get zikr items for this category
    final List<Map<String, dynamic>> zikrItems = await db.query(
      'zikr_items',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );

    List<ZikrItem> azkarList = [];

    final itemIds = zikrItems.map((item) => item['id']).toList();

    final queryPlaceholders = List.generate(
      itemIds.length,
      (index) => '?',
    ).join(',');

    final List<Map<String, dynamic>> allContents = await db.query(
      'zikr_item_content',
      where: 'zikr_item_id IN ($queryPlaceholders)',
      whereArgs: itemIds,
      orderBy: 'content_order',
    );

    for (final item in zikrItems) {
      // Get content for this zikr item
      final contents = allContents
          .where((content) => content['zikr_item_id'] == item['id'])
          .toList();
      final zikrItemId = item['id'];
      final List<ZikrItemContent> contentsList =
          contents
              .map(
                (content) => ZikrItemContent(
                  id: content['id'],
                  zikrItemId: zikrItemId,
                  order: content['content_order'],
                  text: content['text'],
                  category: ZikrItemContentCategory.values.byName(
                    content['category'],
                  ),
                ),
              )
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order));

      if (contents.isEmpty) {
        continue;
      }

      azkarList.add(
        ZikrItem(
          id: item['id'],
          categoryId: categoryId,
          contents: contentsList,
          count: item['repeat'],
          audioUrl: item['audio_url'],
          order: item['item_order'],
        ),
      );
    }

    return azkarList;
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
