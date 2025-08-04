import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/models/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.read(categoryRepositoryProvider);
  return await repository.getAllCategories();
});

final categoryProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  return CategoryNotifier(ref.read(categoryRepositoryProvider));
});

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final CategoryRepository _repository;

  CategoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _repository.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addCategory(String name, int color, String icon) async {
    try {
      final nextId = await _repository.getNextId();
      final category = Category(
        id: nextId,
        name: name,
        color: color,
        icon: icon,
        createdAt: DateTime.now(),
      );
      await _repository.addCategory(category);
      await _loadCategories();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _repository.updateCategory(category);
      await _loadCategories();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> canDeleteCategory(int id) async {
    return !(await _repository.hasSalaryEntries(id));
  }

  Future<void> deleteCategory(int id) async {
    try {
      // 削除前に収入データの存在をチェック
      final hasEntries = await _repository.hasSalaryEntries(id);
      if (hasEntries) {
        throw Exception('収入データが存在するため削除できません。');
      }
      
      await _repository.deleteCategory(id);
      await _loadCategories();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<int>> getDeletedCategoryIds() async {
    return await _repository.getDeletedCategoryIds();
  }
}

final deletedCategoryIdsProvider = FutureProvider<List<int>>((ref) async {
  final categoryNotifier = ref.watch(categoryProvider.notifier);
  return await categoryNotifier.getDeletedCategoryIds();
}); 