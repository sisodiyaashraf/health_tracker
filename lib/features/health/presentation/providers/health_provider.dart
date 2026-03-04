import 'package:flutter/material.dart';
import '../../data/models/health_entry.dart';
import '../../data/repositories/health_repository_impl.dart';

class HealthProvider with ChangeNotifier {
  final HealthRepository _repository;
  List<HealthEntry> _entries = [];

  HealthProvider(this._repository);

  List<HealthEntry> get entries => _entries;

  // 1. IMPROVED: Strict normalization to ignore hours/minutes/seconds
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // --- Centralized Validation Method ---
  bool hasEntryForDate(DateTime date) {
    // We check the local list for any entry matching the YYYY-MM-DD
    return _entries.any((e) => _isSameDay(e.date, date));
  }

  // --- Core Data Operations ---

  Future<void> loadEntries() async {
    try {
      _entries = await _repository.fetchAll();
      // Ensure newest logs are always at the top
      _entries.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading entries: $e");
    }
  }

  Future<bool> saveEntry(HealthEntry entry) async {
    // 🛡️ Double-check validation before saving
    if (hasEntryForDate(entry.date)) return false;

    try {
      await _repository.addEntry(entry);
      // Reload from source to ensure state is perfectly synced with Hive
      await loadEntries();
      return true;
    } catch (e) {
      debugPrint("Error saving entry: $e");
      return false;
    }
  }

  Future<bool> deleteEntry(HealthEntry entry) async {
    try {
      // 2. FIXED: Delete from Repository first
      await _repository.deleteEntry(entry);

      // 3. FIXED: Remove from local list using the same normalized check
      _entries.removeWhere((e) => _isSameDay(e.date, entry.date));

      // 4. CRITICAL: Notify listeners so AddEntryScreen updates its 'alreadyExists' check
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error deleting entry: $e");
      return false;
    }
  }

  // --- Analytics Logic ---

  double get avgSleep {
    if (_entries.isEmpty) return 0;
    final last7 = _entries.take(7).toList();
    final total = last7.map((e) => e.sleepHours).reduce((a, b) => a + b);
    return double.parse((total / last7.length).toStringAsFixed(1));
  }

  double get avgWater {
    if (_entries.isEmpty) return 0;
    final last7 = _entries.take(7).toList();
    final total = last7.map((e) => e.waterIntake).reduce((a, b) => a + b);
    return double.parse((total / last7.length).toStringAsFixed(1));
  }
}
