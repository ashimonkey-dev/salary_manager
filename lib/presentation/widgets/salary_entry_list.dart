import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/category_provider.dart';
import '../providers/salary_provider.dart';
import '../../domain/models/category.dart';
import '../../domain/models/salary_entry.dart';
import '../../core/utils/icon_utils.dart';

class SalaryEntryList extends HookConsumerWidget {
  final int year;
  final int month;

  const SalaryEntryList({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final monthlySalaryAsync = ref.watch(
      monthlySalaryProvider((year: year, month: month))
    );

    return categoriesAsync.when(
      data: (categories) {
        return monthlySalaryAsync.when(
          data: (salaryEntries) {
            if (salaryEntries.isEmpty) {
              return const Center(
                child: Text('給与データがありません'),
              );
            }

            // カテゴリ順にソート
            final sortedEntries = List<SalaryEntry>.from(salaryEntries)
              ..sort((a, b) => a.categoryId.compareTo(b.categoryId));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: sortedEntries.map((entry) {
                  final category = categories.firstWhere(
                    (cat) => cat.id == entry.categoryId,
                    orElse: () => Category(
                      id: entry.categoryId,
                      name: '不明',
                      color: 0xFFCCCCCC,
                      icon: 'help',
                      createdAt: DateTime.now(),
                    ),
                  );

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
                      trailing: Text(
                        '${NumberFormat('#,###').format(entry.amount)}円',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        _showDetailDialog(context, ref, category, [entry]);
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('エラー: $error'),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('エラー: $error'),
      ),
    );
  }



  void _showDetailDialog(
    BuildContext context,
    WidgetRef ref,
    Category category,
    List<SalaryEntry> entries,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(category.color),
              child: Icon(
                IconUtils.getIconData(category.icon),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(category.name),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: entries.map((entry) {
              return _SalaryEntryTile(
                entry: entry,
                onEdit: (double newAmount) async {
                  final updatedEntry = SalaryEntry(
                    id: entry.id,
                    categoryId: entry.categoryId,
                    amount: newAmount,
                    year: entry.year,
                    month: entry.month,
                    createdAt: entry.createdAt,
                  );

                  await ref.read(salaryProvider.notifier).updateSalaryEntry(updatedEntry);
                  // 月次データを更新
                  ref.invalidate(monthlySalaryProvider((year: year, month: month)));
                  // 年次データを更新
                  ref.invalidate(yearlySalaryProvider(year));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('給与を更新しました')),
                    );
                  }
                },
                onDelete: () async {
                  await ref.read(salaryProvider.notifier).deleteSalaryEntry(entry.id);
                  // 月次データを更新
                  ref.invalidate(monthlySalaryProvider((year: year, month: month)));
                  // 年次データを更新
                  ref.invalidate(yearlySalaryProvider(year));
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('給与を削除しました')),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}

class _SalaryEntryTile extends StatefulWidget {
  final SalaryEntry entry;
  final Future<void> Function(double) onEdit;
  final VoidCallback onDelete;

  const _SalaryEntryTile({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SalaryEntryTile> createState() => _SalaryEntryTileState();
}

class _SalaryEntryTileState extends State<_SalaryEntryTile> {
  bool _isEditing = false;
  late TextEditingController _amountController;
  late FocusNode _focusNode;
  double _currentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.entry.amount;
    _amountController = TextEditingController(text: _currentAmount.toStringAsFixed(0));
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(_SalaryEntryTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // エントリーが更新された場合、現在の金額も更新
    if (oldWidget.entry.amount != widget.entry.amount) {
      _currentAmount = widget.entry.amount;
      if (!_isEditing) {
        _amountController.text = _currentAmount.toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 数字のみ
                  LengthLimitingTextInputFormatter(8), // 8桁まで（99,999,999円）
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '金額（0〜99,999,999円）',
                  suffixText: '円',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                final amount = double.tryParse(_amountController.text);
                if (amount != null && amount >= 0 && amount <= 99999999) {
                  await widget.onEdit(amount);
                  setState(() {
                    _isEditing = false;
                    _currentAmount = amount;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('金額は0円〜99,999,999円の範囲で入力してください'),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                _amountController.text = _currentAmount.toStringAsFixed(0);
              },
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          '${NumberFormat('#,###').format(_currentAmount)}円',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  _focusNode.requestFocus();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
} 