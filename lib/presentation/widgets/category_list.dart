import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/category.dart';
import '../providers/category_provider.dart';
import 'edit_category_dialog.dart';
import '../../core/utils/icon_utils.dart';

class CategoryList extends HookConsumerWidget {
  final List<Category> categories;

  const CategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(category.color),
              child: Icon(
                IconUtils.getIconData(category.icon),
                color: Colors.white,
              ),
            ),
            title: Text(category.name),
            subtitle: Text(
              '作成日: ${_formatDate(category.createdAt)}',
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditDialog(context, ref, category);
                } else if (value == 'delete') {
                  _showDeleteDialog(context, ref, category);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('編集'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('削除', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Category category) async {
    // 削除前に収入データの存在をチェック
    final canDelete = await ref.read(categoryProvider.notifier).canDeleteCategory(category.id);
    
    if (!canDelete) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('削除できません'),
            content: Text('「${category.name}」には収入データが存在するため削除できません。\n\n収入データを先に削除してから給与種別を削除してください。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('給与種別削除'),
        content: Text('「${category.name}」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(categoryProvider.notifier).deleteCategory(category.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('給与種別を削除しました')),
                    );
                }
              } catch (error) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
} 