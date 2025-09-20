// Individual Azkar Card
import 'dart:ui';

import 'package:azkar/model.dart';
import 'package:azkar/ui/zikr_item/complete_marker.dart';
import 'package:azkar/ui/zikr_item/counter.dart';
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
      margin: const EdgeInsets.all(16),
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
        onLongPress: () {
          // Reset on long press
          onCountChanged(0);
        },
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Zikr text
                ...buildZikrText(),

                // const SizedBox(height: 20),
                // Notes (if any)
                // if (widget.zikr.notes != null) ...[
                //   Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: Colors.blue.shade50,
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Text(
                //       widget.zikr.notes!,
                //       style: TextStyle(
                //         fontSize: widget.fontSize - 4,
                //         color: Colors.blue.shade700,
                //         fontStyle: FontStyle.italic,
                //       ),
                //       textDirection: TextDirection.rtl,
                //     ),
                //   ),
                //   const SizedBox(height: 20),
                // ],

                // Add an expanded to fill the space
                Expanded(child: Container()),

                // Counter section
                if (zikr.count > 1) ...[
                  ZikrItemCounter(
                    count: currentCount,
                    maxCount: zikr.count,
                    isCompleted: isCompleted,
                    fontSize: fontSize,
                  ),
                ] else ...[
                  // Single repetition
                  if (isCompleted)
                    ZikrItemCompleteMarker(
                      isCompleted: isCompleted,
                      fontSize: fontSize,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildZikrText() {
    return zikr.contents
        .map(
          (content) => Text(content.text, style: TextStyle(fontSize: fontSize)),
        )
        .toList();
  }

  bool get isCompleted => currentCount == zikr.count;
}
