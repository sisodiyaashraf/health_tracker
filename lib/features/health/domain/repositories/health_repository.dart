import '../../data/models/health_entry.dart';
import 'package:hive/hive.dart';

class HealthRepository {
  static const String _boxName = 'health_entries';

  Future<Box<HealthEntry>> _openBox() async {
    return await Hive.openBox<HealthEntry>(_boxName);
  }

  Future<void> addEntry(HealthEntry entry) async {
    final box = await _openBox();
    // Key is the date string (YYYY-MM-DD) to ensure one entry per day
    String key = entry.date.toIso8601String().split('T')[0];
    await box.put(key, entry);
  }

  Future<List<HealthEntry>> getAllEntries() async {
    final box = await _openBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
