import '../../data/models/health_entry.dart';

abstract class IHealthLocalDataSource {
  /// Saves or updates a health entry in local storage.
  Future<void> saveEntry(HealthEntry entry);

  /// Retrieves all recorded health entries, typically sorted by date.
  Future<List<HealthEntry>> getEntries();

  /// NEW: Removes a specific entry from local storage based on its date key.
  Future<void> deleteEntry(HealthEntry entry);
}
