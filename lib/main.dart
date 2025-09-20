import 'package:azkar/constants.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/arabic_numbers.dart';
import 'package:azkar/ui/zikr_item/card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ZikrApp());
}

class ZikrApp extends StatelessWidget {
  const ZikrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Amiri', // Arabic font (you'll need to add this)
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const CategoriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Categories Screen
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<ZikrCategory> categories = [];
  bool isLoading = true;
  double fontSize = AppTheme.fontSize;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final repo = ZikrRepository();
    final loadedCategories = await repo.loadIndex();
    setState(() {
      categories = loadedCategories;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen(title: Constants.appName);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _showFontSizeDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              // leading: category.icon != null
              //     ? CircleAvatar(
              //         backgroundColor: Colors.green.shade100,
              //         child: Icon(category.icon, color: Colors.green.shade700),
              //       )
              //     : null,
              title: Text(
                category.title,
                style: TextStyle(
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              // subtitle: Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     const SizedBox(height: 4),
              //     Text(
              //       category.subtitle,
              //       style: TextStyle(fontSize: fontSize - 8),
              //       textDirection: TextDirection.rtl,
              //     ),
              //   ],
              // ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZikrCategoryDetailScreen(
                      category: category,
                      fontSize: fontSize,
                      onFontSizeChanged: (newSize) {
                        setState(() {
                          fontSize = newSize;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حجم الخط'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مثال على النص',
                style: TextStyle(fontSize: fontSize),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              Slider(
                value: fontSize,
                min: 18,
                max: 32,
                divisions: 10,
                label: fontSize.round().toString(),
                onChanged: (value) {
                  setDialogState(() {
                    fontSize = value;
                  });
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String title) {
    if (title.contains('الصباح')) return Icons.wb_sunny;
    if (title.contains('المساء')) return Icons.nights_stay;
    if (title.contains('النوم')) return Icons.bedtime;
    if (title.contains('المسجد')) return Icons.mosque;
    if (title.contains('الطعام')) return Icons.restaurant;
    if (title.contains('السفر')) return Icons.flight;
    return Icons.menu_book;
  }
}

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
  List<ZikrItem> zikr = [];
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
    final loadedZikr = await repo.loadCategoryZikr(widget.category.id);

    zikrCountMap = <int, int>{};
    for (final zikr in loadedZikr) {
      zikrCountMap[zikr.id] = 0;
    }

    setState(() {
      zikr = loadedZikr;
      zikrCountMap = zikrCountMap;
      isLoading = false;
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
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => _showFontSizeDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${arabicNumber(currentIndex + 1)} من ${arabicNumber(zikr.length)}',
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / zikr.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
          // Azkar content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: zikr.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final zikr = this.zikr[index];
                return ZikrItemCard(
                  zikr: zikr,
                  fontSize: fontSize,
                  currentCount: zikrCountMap[zikr.id] ?? 0,
                  onCountChanged: (count) => setState(() {
                    zikrCountMap[zikr.id] = count;
                  }),
                  onCompleted: () {
                    // Auto-navigate to next zikr after a short delay
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (currentIndex < this.zikr.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    });
                  },
                );
              },
            ),
          ),
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: const Text('السابق'),
                ),
                ElevatedButton(
                  onPressed: currentIndex < this.zikr.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: const Text('التالي'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog() {
    double tempFontSize =
        fontSize; // Use local fontSize instead of widget.fontSize
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حجم الخط'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مثال على النص',
                style: TextStyle(fontSize: tempFontSize),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              Slider(
                value: tempFontSize,
                min: 12,
                max: 32,
                divisions: 20,
                label: tempFontSize.round().toString(),
                onChanged: (value) {
                  setDialogState(() {
                    tempFontSize = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Update local state immediately
                fontSize = tempFontSize;
              });
              widget.onFontSizeChanged(tempFontSize); // Also update parent
              Navigator.pop(context);
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
