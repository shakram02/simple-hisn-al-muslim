import 'dart:async';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/app_bar.dart';
import 'package:azkar/ui/arabic_numbers.dart';
import 'package:azkar/ui/settings/dialog.dart';
import 'package:azkar/ui/zikr_category/complete_marker.dart';
import 'package:azkar/ui/zikr_item/zikr_progress.dart';
import 'package:azkar/ui/zikr_item/card.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Azkar Detail Screen
class ZikrCategoryDetailScreen extends StatefulWidget {
  final ZikrCategory category;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final VoidCallback onThemeToggle;
  const ZikrCategoryDetailScreen({
    super.key,
    required this.category,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.onThemeToggle,
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
  Timer? _wakelockTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadZikr();
    fontSize = widget.fontSize; // Initialize with widget value
    WakelockPlus.enable(); // Keep screen awake
    // Auto-disable wakelock after 10 minutes to save battery
    _wakelockTimer = Timer(const Duration(minutes: 10), () {
      WakelockPlus.disable();
    });
  }

  void _resetWakelockTimer() {
    _wakelockTimer?.cancel();
    WakelockPlus.enable(); // Safe to call even if already enabled
    _wakelockTimer = Timer(const Duration(minutes: 10), () {
      WakelockPlus.disable();
    });
  }

  Future<void> _loadZikr() async {
    final loadedZikr = await ZikrRepository().loadCategoryZikr(
      widget.category.id,
    );
    if (!mounted) return;
    setState(() {
      categoryZikrList = loadedZikr;
      zikrCountMap = {for (final zikr in loadedZikr) zikr.id: 0};
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _wakelockTimer?.cancel();
    WakelockPlus.disable(); // Allow screen to sleep again
    _pageController.dispose();
    super.dispose();
  }

  bool _hasUnsavedProgress() {
    if (isLoading || categoryZikrList.isEmpty) return false;
    var hasAnyProgress = false;
    var allCompleted = true;
    for (final zikr in categoryZikrList) {
      final count = zikrCountMap[zikr.id] ?? 0;
      if (count > 0) hasAnyProgress = true;
      if (count < zikr.count) allCompleted = false;
    }
    return hasAnyProgress && !allCompleted;
  }

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد الخروج'),
          content: const Text('سيتم فقدان تقدمك. هل تريد الخروج؟'),
          actions: [
            TextButton(
              autofocus: true,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('خروج'),
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen(title: widget.category.title);
    }

    return PopScope(
      canPop: !_hasUnsavedProgress(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: ZikrAppBar.getAppBar(
          title: widget.category.title,
          context: context,
          onFontSizeChangeButtonPressed: () {
            showFontSizeDialog(context, fontSize, (newSize) {
              setState(() {
                fontSize = newSize;
                widget.onFontSizeChanged(newSize);
              });
            });
          },
          onThemeToggle: widget.onThemeToggle,
        ),
        body: GestureDetector(
          onTap: _resetWakelockTimer,
          child: Directionality(
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
                            if (currentIndex >= categoryZikrList.length - 1) {
                              return;
                            }

                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOut,
                            );
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

                        child: Text(
                          'السابق',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.fontSize,
                          ),
                        ),
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
                                    _pageController.jumpToPage(
                                      currentIndex + 1,
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Text(
                          'التالي',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

