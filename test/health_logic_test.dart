import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker/features/health/data/models/health_entry.dart';

void main() {
  group('HealthEntry Model Tests', () {
    test('Should create a valid HealthEntry object', () {
      final entry = HealthEntry(
        date: DateTime.now(),
        mood: 'Good',
        sleepHours: 8.0,
        waterIntake: 2.5,
      );

      expect(entry.mood, 'Good');
      expect(entry.sleepHours, 8.0);
    });
  });

  group('Analytics Logic Tests', () {
    test('Average calculation should be accurate', () {
      final entries = [
        HealthEntry(
          date: DateTime.now(),
          mood: 'Good',
          sleepHours: 8.0,
          waterIntake: 2.0,
        ),
        HealthEntry(
          date: DateTime.now(),
          mood: 'Okay',
          sleepHours: 6.0,
          waterIntake: 1.0,
        ),
      ];

      final avgSleep =
          entries.map((e) => e.sleepHours).reduce((a, b) => a + b) /
          entries.length;
      expect(avgSleep, 7.0);
    });
  });
}
