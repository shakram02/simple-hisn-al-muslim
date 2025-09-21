import 'package:azkar/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor.shade700,
        foregroundColor: AppTheme.whiteColor,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
