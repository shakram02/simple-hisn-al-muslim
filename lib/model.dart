class ZikrCategory {
  final int id;
  final String title;

  ZikrCategory({required this.id, required this.title});
}

class ZikrItem {
  final int id;
  final int categoryId;
  final int count;
  final String? audio;
  final String? notes;
  final String? reference;
  final List<ZikrItemContent> contents;

  ZikrItem({
    required this.id,
    required this.categoryId,
    required this.count,
    this.audio,
    this.notes,
    this.reference,
    required this.contents,
  });
}

enum ZikrItemContentCategory { text, count, quran, foreword }

class ZikrItemContent {
  final int id;
  final int zikrItemId;
  final String text;
  final ZikrItemContentCategory category;

  ZikrItemContent({
    required this.id,
    required this.zikrItemId,
    required this.text,
    required this.category,
  });
}
