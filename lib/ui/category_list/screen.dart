import 'package:azkar/constants.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/app_bar.dart';
import 'package:azkar/ui/settings/dialog.dart';
import 'package:azkar/ui/zikr_category/screen.dart';
import 'package:flutter/material.dart';

// Categories Screen
class CategoriesScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final String locale;
  const CategoriesScreen({
    super.key,
    required this.onThemeToggle,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.locale,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<ZikrCategory> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final loadedCategories = await _loadCategories();
      setState(() {
        categories = loadedCategories;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
      setState(() {
        isLoading = false; // Show empty state instead of hanging
      });
    }
  }

  Future<List<ZikrCategory>> _loadCategories() async {
    final repo = ZikrRepository();
    return await repo.loadIndex(widget.locale);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen(title: Constants.appName);
    }

    return Scaffold(
      appBar: ZikrAppBar.getAppBar(
        title: Constants.appName,
        context: context,
        onFontSizeChangeButtonPressed: () {
          showFontSizeDialog(
            context,
            widget.fontSize,
            widget.onFontSizeChanged,
          );
        },
        onThemeToggle: widget.onThemeToggle,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
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
                  style: TextStyle(fontSize: widget.fontSize + 2),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.darkSecondary
                      : AppTheme.secondaryColor,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZikrCategoryDetailScreen(
                        category: category,
                        fontSize: widget.fontSize,
                        onFontSizeChanged: widget.onFontSizeChanged,
                        onThemeToggle: widget.onThemeToggle,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // IconData _getIcon(String title) {
  //   if (title.contains('الصباح')) return Icons.wb_sunny;
  //   if (title.contains('المساء')) return Icons.nights_stay;
  //   if (title.contains('النوم')) return Icons.bedtime;
  //   if (title.contains('المسجد')) return Icons.mosque;
  //   if (title.contains('الطعام')) return Icons.restaurant;
  //   if (title.contains('السفر')) return Icons.flight;
  //   return Icons.menu_book;
  // }
}
