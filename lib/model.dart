import 'package:flutter/material.dart';

class AppLocale {
  final String code;
  final String name;
  final String direction;

  const AppLocale({
    required this.code,
    required this.name,
    required this.direction,
  });

  TextDirection get textDirection =>
      direction == 'rtl' ? TextDirection.rtl : TextDirection.ltr;
}

class ZikrCategory {
  final int id;
  final String title;
  final int displayOrder;
  final bool isFavorite;

  const ZikrCategory({
    required this.id,
    required this.title,
    required this.displayOrder,
    this.isFavorite = false,
  });

  ZikrCategory copyWith({bool? isFavorite}) {
    return ZikrCategory(
      id: id,
      title: title,
      displayOrder: displayOrder,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ZikrSearchResult {
  final int itemId;
  final int categoryId;
  final String categoryTitle;
  final String snippet;

  const ZikrSearchResult({
    required this.itemId,
    required this.categoryId,
    required this.categoryTitle,
    required this.snippet,
  });
}

class ZikrItem {
  final int id;
  final int categoryId;
  final int order;
  final int repeatCount;
  final String? audioUrl;
  final String? transliteration;

  // Arabic markup is always present (the canonical prayer text).
  final String arabicMarkup;

  // Translation in the user's chosen locale; null when locale is 'ar'.
  final String? translation;
  final String? footnote;

  const ZikrItem({
    required this.id,
    required this.categoryId,
    required this.order,
    required this.repeatCount,
    this.audioUrl,
    this.transliteration,
    required this.arabicMarkup,
    this.translation,
    this.footnote,
  });
}
