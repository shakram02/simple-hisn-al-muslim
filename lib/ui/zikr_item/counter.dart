import 'package:flutter/material.dart';
import 'package:azkar/ui/arabic_numbers.dart';

class ZikrItemCounter extends StatelessWidget {
  final int count;
  final int maxCount;
  final bool isCompleted;
  final double fontSize;

  const ZikrItemCounter({
    super.key,
    required this.count,
    required this.maxCount,
    required this.isCompleted,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final arabicCount = arabicNumber(count);
    final arabicMaxCount = arabicNumber(maxCount);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.blue,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'العدد: $arabicCount من $arabicMaxCount',
            style: TextStyle(
              // fontSize: fontSize - 2,
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.green.shade700 : Colors.blue.shade700,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: count / maxCount,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? Colors.green : Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCompleted ? 'مكتمل ✓' : 'اضغط للعد • اضغط مطولاً للإعادة',
            style: TextStyle(
              // fontSize: fontSize - 6,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
