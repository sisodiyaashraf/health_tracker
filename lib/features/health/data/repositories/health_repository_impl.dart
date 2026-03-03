import '../models/health_entry.dart';
import '../../domain/repositories/i_health_local_datasource.dart';

class HealthRepository {
  final IHealthLocalDataSource localDataSource;

  HealthRepository({required this.localDataSource});

  Future<void> addEntry(HealthEntry entry) => localDataSource.saveEntry(entry);
  Future<List<HealthEntry>> fetchAll() => localDataSource.getEntries();
}
