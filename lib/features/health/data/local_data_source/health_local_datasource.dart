import 'package:hive/hive.dart';
import '../../domain/repositories/i_health_local_datasource.dart';
import '../models/health_entry.dart';

class HealthLocalDataSource implements IHealthLocalDataSource {
  static const String _boxName = 'health_entries';

  @override
  Future<void> saveEntry(HealthEntry entry) async {
    final box = await Hive.openBox<HealthEntry>(_boxName);
    // Use the date as the key to enforce the one-entry-per-day rule
    String key = entry.date.toIso8601String().split('T')[0];
    await box.put(key, entry);
  }

  @override
  Future<List<HealthEntry>> getEntries() async {
    final box = await Hive.openBox<HealthEntry>(_boxName);
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
