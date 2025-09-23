class ZikrCategory {
  final int id;
  final String title;
  final int order;

  ZikrCategory({required this.id, required this.title, required this.order});
}

class ZikrItem {
  final int id;
  final int categoryId;
  final int order;
  final int count;
  final String? audioUrl;
  final String? notes;
  final String? reference;
  final List<ZikrItemContent> contents;

  ZikrItem({
    required this.id,
    required this.categoryId,
    required this.order,
    required this.count,
    this.audioUrl,
    this.notes,
    this.reference,
    required this.contents,
  });
}

enum ZikrItemContentCategory { text, count, quran, foreword }

class ZikrItemContent {
  final int id;
  final int zikrItemId;
  final int order;
  final String text;
  final ZikrItemContentCategory category;

  ZikrItemContent({
    required this.id,
    required this.zikrItemId,
    required this.order,
    required this.text,
    required this.category,
  });
}
