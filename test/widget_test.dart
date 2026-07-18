import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisab/app.dart';
import 'package:hisab/core/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows the Hisab splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: HisabApp(),
      ),
    );

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
  });
}
