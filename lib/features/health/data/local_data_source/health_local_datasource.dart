import 'package:hive/hive.dart';
import '../../domain/repositories/i_health_local_datasource.dart';
import '../models/health_entry.dart';

class HealthLocalDataSource implements IHealthLocalDataSource {
  static const String _boxName = 'health_entries';

  // Helper to maintain key consistency across save/delete
  String _generateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  @override
  Future<void> saveEntry(HealthEntry entry) async {
    final box = await Hive.openBox<HealthEntry>(_boxName);
    final String key = _generateKey(entry.date);
    await box.put(key, entry);
  }

  // NEW: Implementation of the delete method
  @override
  Future<void> deleteEntry(HealthEntry entry) async {
    final box = await Hive.openBox<HealthEntry>(_boxName);
    final String key = _generateKey(entry.date);

    // Directly removes the record associated with this date key
    await box.delete(key);
  }

  @override
  Future<List<HealthEntry>> getEntries() async {
    final box = await Hive.openBox<HealthEntry>(_boxName);
    // Returns the list sorted newest to oldest for the Home Screen
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
