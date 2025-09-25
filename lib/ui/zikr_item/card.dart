// Individual Azkar Card
import 'package:azkar/constants.dart';
import 'package:azkar/model.dart';
import 'package:flutter/material.dart';

class ZikrItemCard extends StatelessWidget {
  final ZikrItem zikr;
  final double fontSize;
  final int currentCount;
  final Function(int) onCountChanged;
  final VoidCallback onCompleted;

  const ZikrItemCard({
    super.key,
    required this.zikr,
    required this.fontSize,
    required this.currentCount,
    required this.onCountChanged,
    required this.onCompleted,
  });

  // Replace the ZikrItemCard build method:
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: GestureDetector(
        onTap: () {
          if (currentCount < zikr.count) {
            onCountChanged(currentCount + 1);
          }
          // Check if just completed
          if (currentCount + 1 == zikr.count) {
            onCompleted();
          }
        },
        // onLongPress: () {
        //   // Reset on long press
        //   onCountChanged(0);
        // },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.primaryColor.shade700
                  : AppTheme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: buildZikrTextContentWidgets(context)),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildZikrTextContentWidgets(BuildContext context) {
    final widgets = <Widget>[];

    final textCategoryStyle = TextStyle(
      fontSize: fontSize,
      // fontFamily: AppTheme.textFontFamily,
    );
    final countCategoryStyle = TextStyle(
      fontSize: fontSize * 0.6,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.darkMutedColor
          : AppTheme.mutedColor.shade500,
    );
    final quranCategoryStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: AppTheme.quranFontFamily,
      // fontWeight: FontWeight.bold,
    );
    final forewordCategoryStyle = TextStyle(
      fontSize: fontSize * 0.8,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.darkMutedColor
          : AppTheme.mutedColor.shade700,
      fontFamily: AppTheme.quranFontFamily,
    );

    for (final content in zikr.contents) {
      var style = textCategoryStyle;

      if (content.category == ZikrItemContentCategory.text) {
        style = textCategoryStyle;
      } else if (content.category == ZikrItemContentCategory.count) {
        style = countCategoryStyle;
      } else if (content.category == ZikrItemContentCategory.quran) {
        style = quranCategoryStyle;
      } else if (content.category == ZikrItemContentCategory.foreword) {
        style = forewordCategoryStyle;
      }

      widgets.add(
        Text(content.text, style: style, textAlign: TextAlign.center),
      );

      if (content.category == ZikrItemContentCategory.quran) {
        widgets.add(const SizedBox(height: 32));
      }

      if (content.category == ZikrItemContentCategory.foreword) {
        // Add horizontal line
        widgets.add(const SizedBox(height: 12));
        // widgets.add(const SizedBox(height: 16));
      }

      // Add space before text items
      if (content.category == ZikrItemContentCategory.text) {
        widgets.add(const SizedBox(height: 32));
      }
    }

    return widgets;
  }

  bool get isCompleted => currentCount == zikr.count;
}
