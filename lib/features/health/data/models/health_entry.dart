import 'package:hive/hive.dart';

part 'health_entry.g.dart';

@HiveType(typeId: 0)
class HealthEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String mood; // "Good", "Okay", "Bad"

  @HiveField(2)
  final double sleepHours;

  @HiveField(3)
  final double waterIntake;

  @HiveField(4)
  final String? note;

  HealthEntry({
    required this.date,
    required this.mood,
    required this.sleepHours,
    required this.waterIntake,
    this.note,
  });
}
