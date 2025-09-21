import 'package:azkar/constants.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/font_sizer/dialog.dart';
import 'package:azkar/ui/font_sizer/font_pref.dart';
import 'package:azkar/ui/zikr_category/screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ZikrApp());
}

// Add this widget to test fonts
class ZikrApp extends StatelessWidget {
  const ZikrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: AppTheme.primaryColor,
        // fontFamily: AppTheme.quranFontFamily,
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
  double fontSize = 0;
  FontSharedPreferences fontSharedPreferences = FontSharedPreferences();

  @override
  void initState() {
    super.initState();

    // parallel wait for future
    Future.wait([_loadCategories(), fontSharedPreferences.getFontSize()]).then((
      values,
    ) {
      final loadedCategories = values[0] as List<ZikrCategory>;
      final prefFontSize = values[1] as double?;
      debugPrint('prefs fontSize: $prefFontSize');
      final loadedFontSize = prefFontSize ?? AppTheme.fontSize;
      setState(() {
        categories = loadedCategories;
        fontSize = loadedFontSize;
        isLoading = false;
      });
    });
  }

  Future<List<ZikrCategory>> _loadCategories() async {
    final repo = ZikrRepository();
    return await repo.loadIndex();
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                category.title,
                style: TextStyle(fontSize: fontSize + 2),
                textDirection: TextDirection.rtl,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryColor,
              ),
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
