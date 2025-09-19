import 'package:flutter/material.dart';

void main() {
  runApp(const AzkarApp());
}

class AzkarApp extends StatelessWidget {
  const AzkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أذكار المسلم',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Amiri', // Arabic font (you'll need to add this)
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const CategoriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Data Models
class AzkarCategory {
  final String id;
  final String title;
  final String subtitle;
  final List<Zikr> azkar;
  final IconData icon;

  AzkarCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.azkar,
    required this.icon,
  });
}

class Zikr {
  final String id;
  final String text;
  final int repetitions;
  final String? notes;
  final String? reference;
  int currentCount;

  Zikr({
    required this.id,
    required this.text,
    required this.repetitions,
    this.notes,
    this.reference,
    this.currentCount = 0,
  });

  bool get isCompleted => currentCount >= repetitions;
  double get progress => repetitions > 0 ? currentCount / repetitions : 1.0;
}

// Categories Screen
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  double fontSize = 18.0;

  final List<AzkarCategory> categories = [
    AzkarCategory(
      id: 'morning',
      title: 'أذكار الصباح',
      subtitle: 'Morning Supplications',
      icon: Icons.wb_sunny,
      azkar: [
        Zikr(
          id: 'morning_1',
          text: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          repetitions: 9,
          notes: 'Say when starting morning azkar',
        ),
        Zikr(
          id: 'morning_2',
          text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          repetitions: 1,
        ),
        // Add more azkar...
      ],
    ),
    AzkarCategory(
      id: 'evening',
      title: 'أذكار المساء',
      subtitle: 'Evening Supplications',
      icon: Icons.nights_stay,
      azkar: [
        Zikr(
          id: 'evening_1',
          text: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          repetitions: 1,
        ),
        Zikr(
          id: 'morning_2',
          text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          repetitions: 2,
        ),
        Zikr(
          id: 'evening_1',
          text: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          repetitions: 1,
        ),
        // Add more azkar...
      ],
    ),
    AzkarCategory(
      id: 'sleep',
      title: 'أذكار النوم',
      subtitle: 'الأذكار الذي يقرأها المصلي قبل النوم',
      icon: Icons.bedtime,
      azkar: [
        Zikr(
          id: 'sleep_1',
          text: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي وَبِكَ أَرْفَعُهُ',
          repetitions: 1,
        ),
        // Add more azkar...
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكار المسلم'),
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
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Icon(category.icon, color: Colors.green.shade700),
              ),
              title: Text(
                category.title,
                style: TextStyle(
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    category.subtitle,
                    style: TextStyle(fontSize: fontSize - 8),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AzkarDetailScreen(
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
}

// Azkar Detail Screen
class AzkarDetailScreen extends StatefulWidget {
  final AzkarCategory category;
  final double fontSize;
  final Function(double) onFontSizeChanged;

  const AzkarDetailScreen({
    super.key,
    required this.category,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  late double fontSize; // Add this local state

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fontSize = widget.fontSize; // Initialize with widget value
  }

  @override
  Widget build(BuildContext context) {
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
                  '${currentIndex + 1} من ${widget.category.azkar.length}',
                  style: TextStyle(
                    fontSize: fontSize - 2,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / widget.category.azkar.length,
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
              itemCount: widget.category.azkar.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final zikr = widget.category.azkar[index];
                return AzkarCard(
                  zikr: zikr,
                  fontSize: fontSize,
                  onCountChanged: () => setState(() {}),
                  onCompleted: () {
                    // Auto-navigate to next zikr after a short delay
                    Future.delayed(const Duration(milliseconds: 400), () {
                      // Debug
                      if (currentIndex < widget.category.azkar.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
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
                  onPressed: currentIndex < widget.category.azkar.length - 1
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

// Individual Azkar Card
class AzkarCard extends StatelessWidget {
  final Zikr zikr;
  final double fontSize;
  final VoidCallback onCountChanged;
  final VoidCallback onCompleted;

  const AzkarCard({
    super.key,
    required this.zikr,
    required this.fontSize,
    required this.onCountChanged,
    required this.onCompleted,
  });

  // Replace the AzkarCard build method:
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          if (zikr.currentCount < zikr.repetitions) {
            zikr.currentCount++;
            onCountChanged();
          }
          // Check if just completed
          if (zikr.currentCount == zikr.repetitions) {
            onCompleted();
          }
        },
        onLongPress: () {
          // Reset on long press
          zikr.currentCount = 0;
          onCountChanged();
        },
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Zikr text
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        zikr.text,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Notes (if any)
                if (zikr.notes != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      zikr.notes!,
                      style: TextStyle(
                        fontSize: fontSize - 4,
                        color: Colors.blue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Counter section
                if (zikr.repetitions > 1) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: zikr.isCompleted
                          ? Colors.green.shade50
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: zikr.isCompleted ? Colors.green : Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'العدد: ${zikr.currentCount} / ${zikr.repetitions}',
                          style: TextStyle(
                            fontSize: fontSize - 2,
                            fontWeight: FontWeight.bold,
                            color: zikr.isCompleted
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: zikr.progress,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            zikr.isCompleted ? Colors.green : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          zikr.isCompleted
                              ? 'مكتمل ✓'
                              : 'اضغط للعد • اضغط مطولاً للإعادة',
                          style: TextStyle(
                            fontSize: fontSize - 6,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Single repetition
                  if (zikr.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: zikr.isCompleted
                            ? Colors.green.shade50
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: zikr.isCompleted ? Colors.green : Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'مكتمل ✓',
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          fontWeight: FontWeight.bold,
                          color: zikr.isCompleted
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
