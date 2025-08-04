import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/category_provider.dart';
import '../providers/salary_provider.dart';
import '../../domain/models/category.dart';
import '../../domain/models/salary_entry.dart';

class MonthlySalaryChart extends HookConsumerWidget {
  final int year;
  final int month;

  const MonthlySalaryChart({
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
            final chartData = _createChartData(categories, salaryEntries);
            final total = salaryEntries.fold<double>(
              0, (sum, entry) => sum + entry.amount
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      const Text(
                        '総額',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(total)}円',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 250, // 固定の高さを設定
                    child: chartData.isEmpty
                        ? const Center(
                            child: Text('データがありません'),
                          )
                        : PieChart(
                            PieChartData(
                              sections: chartData,
                              centerSpaceRadius: 40,
                              sectionsSpace: 0, // 区切り線を削除
                              startDegreeOffset: -90,
                              borderData: FlBorderData(show: false), // 境界線を非表示
                            ),
                          ),
                  ),
                ],
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

  List<PieChartSectionData> _createChartData(
    List<Category> categories,
    List<SalaryEntry> salaryEntries,
  ) {
    final Map<int, double> categoryTotals = {};
    
    for (final entry in salaryEntries) {
      categoryTotals[entry.categoryId] = 
          (categoryTotals[entry.categoryId] ?? 0) + entry.amount;
    }

    final total = categoryTotals.values.fold<double>(0, (sum, amount) => sum + amount);
    
    if (total == 0) return [];

    return categoryTotals.entries.map((entry) {
      final category = categories.firstWhere(
        (cat) => cat.id == entry.key,
        orElse: () => Category(
          id: entry.key,
          name: '不明',
          color: 0xFFCCCCCC,
          icon: 'help',
          createdAt: DateTime.now(),
        ),
      );

      final percentage = (entry.value / total * 100);
      
      return PieChartSectionData(
        color: Color(category.color),
        value: entry.value,
        title: percentage < 5 ? '' : '${percentage.toStringAsFixed(1)}%', // 5%未満は表示しない
        radius: 60,
        titleStyle: TextStyle(
          fontSize: percentage < 10 ? 10 : 12, // 小さいセクションはフォントサイズを小さく
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
} 