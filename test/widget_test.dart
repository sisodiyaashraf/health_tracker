import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker/main.dart';

void main() {
  testWidgets('Onboarding shows on first run', (WidgetTester tester) async {
    // Build our app with isFirstRun set to true
    await tester.pumpWidget(const MyApp(isFirstRun: true));

    // Verify that the Onboarding text appears (adjust text to match your OnboardingScreen)
    expect(find.text('Track Your Vitals'), findsOneWidget);
    expect(find.text('My Health'), findsNothing);
  });

  testWidgets('Home Screen shows when not first run', (
    WidgetTester tester,
  ) async {
    // Build our app with isFirstRun set to false
    await tester.pumpWidget(const MyApp(isFirstRun: false));

    // Verify that the Home Screen (My Health) title appears
    expect(find.text('My Health'), findsOneWidget);
  });
}
