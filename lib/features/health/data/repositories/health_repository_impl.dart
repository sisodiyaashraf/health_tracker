import '../models/health_entry.dart';
import '../../domain/repositories/i_health_local_datasource.dart';

class HealthRepository {
  final IHealthLocalDataSource localDataSource;

  HealthRepository({required this.localDataSource});

  // 1. Existing methods
  Future<void> addEntry(HealthEntry entry) => localDataSource.saveEntry(entry);
  Future<List<HealthEntry>> fetchAll() => localDataSource.getEntries();

  // 2. NEW: Delete method to bridge the Provider and the Data Source
  Future<void> deleteEntry(HealthEntry entry) async {
    await localDataSource.deleteEntry(entry);
  }
}
