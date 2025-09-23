import 'package:azkar/constants.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/arabic_numbers.dart';
import 'package:azkar/ui/font_sizer/dialog.dart';
import 'package:azkar/ui/zikr_category/complete_marker.dart';
import 'package:azkar/ui/zikr_item/zikr_progress.dart';
import 'package:azkar/ui/zikr_item/card.dart';
import 'package:flutter/material.dart';

// Azkar Detail Screen
class ZikrCategoryDetailScreen extends StatefulWidget {
  final ZikrCategory category;
  final double fontSize;
  final Function(double) onFontSizeChanged;

  const ZikrCategoryDetailScreen({
    super.key,
    required this.category,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  State<ZikrCategoryDetailScreen> createState() =>
      _ZikrCategoryDetailScreenState();
}

class _ZikrCategoryDetailScreenState extends State<ZikrCategoryDetailScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  double fontSize = 0; // Add this local state
  Map<int, int> zikrCountMap = {};
  List<ZikrItem> categoryZikrList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadZikr();
    fontSize = widget.fontSize; // Initialize with widget value
  }

  void _loadZikr() async {
    final repo = ZikrRepository();
    repo.loadCategoryZikr(widget.category.id).then((loadedZikr) {
      zikrCountMap = <int, int>{};
      for (final zikr in loadedZikr) {
        zikrCountMap[zikr.id] = 0;
      }

      setState(() {
        categoryZikrList = loadedZikr;
        zikrCountMap = zikrCountMap;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen(title: widget.category.title);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor.shade700,
        foregroundColor: AppTheme.whiteColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => showFontSizeDialog(context, fontSize, (newSize) {
              setState(() {
                fontSize = newSize;
              });
            }),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _buildZikrItemProgress(),
            ),
            // Azkar content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryZikrList.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final zikr = categoryZikrList[index];
                  return ZikrItemCard(
                    zikr: zikr,
                    fontSize: fontSize,
                    currentCount: zikrCountMap[zikr.id] ?? 0,
                    onCountChanged: (count) => setState(() {
                      zikrCountMap[zikr.id] = count;
                    }),
                    onCompleted: () {
                      // Auto-navigate to next zikr after a short delay
                      Future.delayed(const Duration(milliseconds: 150), () {
                        if (currentIndex < categoryZikrList.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: currentIndex > 0
                        ? () {
                            _pageController.jumpToPage(currentIndex - 1);
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.secondaryColor,
                    ),

                    child: const Text('السابق'),
                  ),
                  Text(
                    '${arabicNumber(currentIndex + 1)} من ${arabicNumber(categoryZikrList.length)}',
                  ),
                  TextButton(
                    onPressed: currentIndex < categoryZikrList.length - 1
                        ? () {
                            Future.delayed(
                              const Duration(milliseconds: 50),
                              () {
                                _pageController.jumpToPage(currentIndex + 1);
                              },
                            );
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.secondaryColor,
                    ),
                    child: const Text('التالي'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZikrItemProgress() {
    final currentZikrItemHasCount = categoryZikrList[currentIndex].count > 1;
    final currentZikrItemCounter =
        zikrCountMap[categoryZikrList[currentIndex].id] ?? 0;
    final currentZikrItemIsCompleted =
        currentZikrItemCounter == categoryZikrList[currentIndex].count;

    if (currentZikrItemIsCompleted) {
      return Column(
        children: [const ZikrItemCompleteMarker(), const SizedBox(height: 14)],
      );
    }

    if (!currentZikrItemHasCount) {
      return Column(children: [const Text(''), const SizedBox(height: 14)]);
    }

    if (currentZikrItemHasCount) {
      return ZikrProgress(
        count: currentZikrItemCounter,
        maxCount: categoryZikrList[currentIndex].count,
        isCompleted: currentZikrItemIsCompleted,
        fontSize: fontSize,
      );
    }

    return const SizedBox.shrink();
  }
}
