import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repositories/salary_repository.dart';
import '../../domain/models/salary_entry.dart';

final salaryRepositoryProvider = Provider<SalaryRepository>((ref) {
  return SalaryRepository();
});

final salaryProvider = StateNotifierProvider<SalaryNotifier, AsyncValue<List<SalaryEntry>>>((ref) {
  return SalaryNotifier(ref.read(salaryRepositoryProvider));
});

final monthlySalaryProvider = StateNotifierProvider.family<MonthlySalaryNotifier, AsyncValue<List<SalaryEntry>>, ({int year, int month})>((ref, params) {
  return MonthlySalaryNotifier(ref.read(salaryRepositoryProvider), params.year, params.month);
});

final yearlySalaryProvider = StateNotifierProvider.family<YearlySalaryNotifier, AsyncValue<List<SalaryEntry>>, int>((ref, year) {
  return YearlySalaryNotifier(ref.read(salaryRepositoryProvider), year);
});

class SalaryNotifier extends StateNotifier<AsyncValue<List<SalaryEntry>>> {
  final SalaryRepository _repository;

  SalaryNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSalaryEntries();
  }

  Future<void> _loadSalaryEntries() async {
    state = const AsyncValue.loading();
    try {
      final entries = await _repository.getAllSalaryEntries();
      state = AsyncValue.data(entries);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSalaryEntry(int categoryId, double amount, int year, int month) async {
    try {
      final nextId = await _repository.getNextId();
      final entry = SalaryEntry(
        id: nextId,
        categoryId: categoryId,
        amount: amount,
        year: year,
        month: month,
        createdAt: DateTime.now(),
      );
      await _repository.addSalaryEntry(entry);
      await _loadSalaryEntries();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSalaryEntry(SalaryEntry entry) async {
    try {
      await _repository.updateSalaryEntry(entry);
      await _loadSalaryEntries();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSalaryEntry(int id) async {
    try {
      await _repository.deleteSalaryEntry(id);
      await _loadSalaryEntries();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class MonthlySalaryNotifier extends StateNotifier<AsyncValue<List<SalaryEntry>>> {
  final SalaryRepository _repository;
  final int _year;
  final int _month;

  MonthlySalaryNotifier(this._repository, this._year, this._month) 
      : super(const AsyncValue.loading()) {
    _loadMonthlySalaryEntries();
  }

  Future<void> _loadMonthlySalaryEntries() async {
    state = const AsyncValue.loading();
    try {
      final entries = await _repository.getSalaryEntriesByYearMonth(_year, _month);
      state = AsyncValue.data(entries);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadMonthlySalaryEntries();
  }
}

class YearlySalaryNotifier extends StateNotifier<AsyncValue<List<SalaryEntry>>> {
  final SalaryRepository _repository;
  final int _year;

  YearlySalaryNotifier(this._repository, this._year) 
      : super(const AsyncValue.loading()) {
    _loadYearlySalaryEntries();
  }

  Future<void> _loadYearlySalaryEntries() async {
    state = const AsyncValue.loading();
    try {
      final entries = await _repository.getSalaryEntriesByYear(_year);
      state = AsyncValue.data(entries);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadYearlySalaryEntries();
  }
} 