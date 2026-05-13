import 'package:azkar/constants.dart';
import 'package:azkar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app boots and renders the loading screen', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ZikrApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(Constants.appName), findsOneWidget);
  });
}
