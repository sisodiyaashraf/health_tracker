import '../../data/models/health_entry.dart';

abstract class IHealthLocalDataSource {
  Future<void> saveEntry(HealthEntry entry);
  Future<List<HealthEntry>> getEntries();
}
