import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/category.dart';
import '../adapters/category_adapter.dart';
import 'salary_repository.dart';

class CategoryRepository {
  static const String _boxName = 'categories';
  static const String _deletedBoxName = 'deletedCategoryIds';
  late Box<Category> _box;
  late Box<int> _deletedBox;
  SalaryRepository? _salaryRepository;

  Future<void> initialize() async {
    Hive.registerAdapter(CategoryAdapter());
    _box = await Hive.openBox<Category>(_boxName);
    _deletedBox = await Hive.openBox<int>(_deletedBoxName);
  }

  void setSalaryRepository(SalaryRepository salaryRepository) {
    _salaryRepository = salaryRepository;
  }

  Future<List<Category>> getAllCategories() async {
    return _box.values.toList();
  }

  Future<Category?> getCategoryById(int id) async {
    return _box.get(id);
  }

  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> deleteCategory(int id) async {
    await _box.delete(id);
    // 削除されたカテゴリーIDを記録
    await _deletedBox.add(id);
  }

  Future<List<int>> getDeletedCategoryIds() async {
    return _deletedBox.values.toList();
  }

  Future<bool> hasSalaryEntries(int categoryId) async {
    if (_salaryRepository == null) {
      throw Exception('SalaryRepositoryが設定されていません');
    }
    final allEntries = await _salaryRepository!.getAllSalaryEntries();
    return allEntries.any((entry) => entry.categoryId == categoryId);
  }

  Future<int> getNextId() async {
    if (_box.isEmpty) return 1;
    return _box.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void dispose() {
    _box.close();
    _deletedBox.close();
    _salaryRepository?.dispose();
  }
} 