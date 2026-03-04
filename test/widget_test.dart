import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker/main.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 1. Setup a clean environment before every test
  setUp(() async {
    await setUpTestHive();
    // Initialize mock values for SharedPreferences
    SharedPreferences.setMockInitialValues({});
  });

  // 2. Clean up after every test
  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('Onboarding shows on first run', (WidgetTester tester) async {
    // We pass true directly to the widget for testing
    await tester.pumpWidget(const MyApp(isFirstRun: true));

    // Wait for all animations (like the radial gradient fade-in) to settle
    await tester.pumpAndSettle();

    // Verifies the first page of onboarding is visible
    expect(find.text("Log Your Daily Vitals"), findsOneWidget);
  });

  testWidgets('Home Screen shows when not first run', (
    WidgetTester tester,
  ) async {
    // We pass false to skip onboarding and go to Home
    await tester.pumpWidget(const MyApp(isFirstRun: false));

    // pump() handles the initial build, pumpAndSettle() waits for the list animations
    await tester.pump();
    await tester.pumpAndSettle();

    // SliverAppBar.large renders the title twice for transition effects.
    // findsAtLeastNWidgets(1) ensures we see at least one "My Health" title.
    expect(find.text("My Health"), findsAtLeastNWidgets(1));

    // Verify the New Entry FAB exists
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });
}
