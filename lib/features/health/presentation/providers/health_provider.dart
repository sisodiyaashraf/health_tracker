import 'package:flutter/material.dart';
import '../../data/models/health_entry.dart';
import '../../data/repositories/health_repository_impl.dart'; // Updated path

class HealthProvider with ChangeNotifier {
  // Inject the repository instead of hardcoding it
  final HealthRepository _repository;
  List<HealthEntry> _entries = [];

  // Constructor requires the repository
  HealthProvider(this._repository);

  List<HealthEntry> get entries => _entries;

  Future<void> loadEntries() async {
    try {
      // Use the new fetchAll method from your repository/datasource setup
      _entries = await _repository.fetchAll();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading entries: $e");
    }
  }

  Future<bool> saveEntry(HealthEntry entry) async {
    try {
      await _repository.addEntry(entry);
      // Reload to keep the UI in sync with the data source
      await loadEntries();
      return true;
    } catch (e) {
      debugPrint("Error saving entry: $e");
      return false;
    }
  }

  // --- Logic for Analytics: Last 7 Days ---

  double get avgSleep {
    if (_entries.isEmpty) return 0;
    final last7 = _entries.take(7);
    final total = last7.map((e) => e.sleepHours).reduce((a, b) => a + b);
    return total / last7.length;
  }

  double get avgWater {
    if (_entries.isEmpty) return 0;
    final last7 = _entries.take(7);
    final total = last7.map((e) => e.waterIntake).reduce((a, b) => a + b);
    return total / last7.length;
  }
}
