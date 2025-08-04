import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/salary_entry.dart';
import '../adapters/salary_entry_adapter.dart';

class SalaryRepository {
  static const String _boxName = 'salaryEntries';
  late Box<SalaryEntry> _box;

  Future<void> initialize() async {
    Hive.registerAdapter(SalaryEntryAdapter());
    _box = await Hive.openBox<SalaryEntry>(_boxName);
  }

  Future<List<SalaryEntry>> getAllSalaryEntries() async {
    return _box.values.toList();
  }

  Future<List<SalaryEntry>> getSalaryEntriesByYearMonth(int year, int month) async {
    return _box.values
        .where((entry) => entry.year == year && entry.month == month)
        .toList();
  }

  Future<List<SalaryEntry>> getSalaryEntriesByYear(int year) async {
    return _box.values
        .where((entry) => entry.year == year)
        .toList();
  }

  Future<SalaryEntry?> getSalaryEntryById(int id) async {
    return _box.get(id);
  }

  Future<void> addSalaryEntry(SalaryEntry entry) async {
    await _box.put(entry.id, entry);
  }

  Future<void> updateSalaryEntry(SalaryEntry entry) async {
    await _box.put(entry.id, entry);
  }

  Future<void> deleteSalaryEntry(int id) async {
    await _box.delete(id);
  }

  Future<int> getNextId() async {
    if (_box.isEmpty) return 1;
    return _box.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void dispose() {
    _box.close();
  }
} 