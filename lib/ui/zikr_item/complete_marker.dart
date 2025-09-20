import 'package:flutter/material.dart';

class ZikrItemCompleteMarker extends StatelessWidget {
  final bool isCompleted;
  final double fontSize;
  const ZikrItemCompleteMarker({
    super.key,
    required this.isCompleted,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.blue,
          width: 2,
        ),
      ),
      child: Text(
        'مكتمل ✓',
        style: TextStyle(
          fontSize: fontSize - 2,
          fontWeight: FontWeight.bold,
          color: isCompleted ? Colors.green.shade700 : Colors.blue.shade700,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
