import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker/features/health/data/local_data_source/health_local_datasource.dart';
import 'package:health_tracker/features/health/data/repositories/health_repository_impl.dart';
import 'package:health_tracker/features/health/presentation/providers/health_provider.dart';

void main() {
  group('HealthProvider Tests', () {
    // 1. Setup the dependencies required by the Provider
    final dataSource = HealthLocalDataSource();
    final repository = HealthRepository(localDataSource: dataSource);

    test('Initial entries should be empty', () {
      // 2. Pass the repository as the required positional argument
      final provider = HealthProvider(repository);
      expect(provider.entries.isEmpty, true);
    });

    test('Average sleep calculation should be correct', () {
      final provider = HealthProvider(repository);
      // You can manually set entries here for logic testing
      expect(provider.avgSleep, 0.0);
    });
  });
}
