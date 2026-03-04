import '../../data/models/health_entry.dart';
import 'package:hive/hive.dart';

class HealthRepository {
  static const String _boxName = 'health_entries';

  // Helper to open the box consistently
  Future<Box<HealthEntry>> _openBox() async {
    return await Hive.openBox<HealthEntry>(_boxName);
  }

  // Generate a unique key based on the date (YYYY-MM-DD)
  String _generateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  Future<void> addEntry(HealthEntry entry) async {
    final box = await _openBox();
    final String key = _generateKey(entry.date);
    await box.put(key, entry);
  }

  // NEW: Delete entry from Hive using the unique date key
  Future<void> deleteEntry(HealthEntry entry) async {
    final box = await _openBox();
    final String key = _generateKey(entry.date);

    // Removes the specific entry from local storage
    await box.delete(key);
  }

  // Renamed to fetchAll for consistency with Provider
  Future<List<HealthEntry>> fetchAll() async {
    final box = await _openBox();
    // Return list sorted newest to oldest
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
