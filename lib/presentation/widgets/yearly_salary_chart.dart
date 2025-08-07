import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/category_provider.dart';
import '../providers/salary_provider.dart';
import '../../domain/models/category.dart';
import '../../domain/models/salary_entry.dart';
import '../../core/constants.dart';

class YearlySalaryChart extends HookConsumerWidget {
  final int year;

  const YearlySalaryChart({
    super.key,
    required this.year,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final yearlySalaryAsync = ref.watch(yearlySalaryProvider(year));

    return categoriesAsync.when(
      data: (categories) {
        return yearlySalaryAsync.when(
          data: (salaryEntries) {
            // 不明なカテゴリーIDを収集
            final unknownCategoryIds = <int>{};
            for (final entry in salaryEntries) {
              if (entry.year == year && !categories.any((cat) => cat.id == entry.categoryId)) {
                unknownCategoryIds.add(entry.categoryId);
              }
            }

            // 不明なカテゴリーを追加
            final allCategories = List<Category>.from(categories);
            for (final unknownId in unknownCategoryIds) {
              allCategories.add(Category(
                id: unknownId,
                name: '不明',
                color: 0xFFCCCCCC, // 月別画面と同じグレー色
                icon: 'help',
                createdAt: DateTime.now(),
              ));
            }

            final chartData = _createChartData(allCategories, salaryEntries);
            final total = salaryEntries.fold<double>(
              0, (sum, entry) => sum + entry.amount
            );

            // その年度で実際に使用されているカテゴリのみを抽出
            final usedCategoryIds = <int>{};
            for (final entry in salaryEntries) {
              if (entry.year == year) {
                usedCategoryIds.add(entry.categoryId);
              }
            }
            final usedCategories = allCategories.where((cat) => usedCategoryIds.contains(cat.id)).toList();

            return Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 8.0, top: 0, bottom: 16.0),
              child: Column(
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
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 500, // グラフの高さを調整
                    child: chartData.isEmpty
                        ? const Center(
                            child: Text('データがありません'),
                          )
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: _getMaxY(chartData),
                              barTouchData: BarTouchData(enabled: false),
                              groupsSpace: 0,
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() >= 0 && value.toInt() < 12) {
                                        return Text(AppConstants.monthNames[value.toInt()]);
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      final maxY = _getMaxY(chartData);
                                      final unit = maxY / 10; // 最高金額の10分の1
                                      
                                      if (value % unit == 0) {
                                        return Text('${(value / 10000).toInt()}万');
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: chartData,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // 凡例を表示（その年度で使用されているカテゴリのみ）
                  _buildLegend(usedCategories),
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

  List<BarChartGroupData> _createChartData(
    List<Category> categories,
    List<SalaryEntry> salaryEntries,
  ) {
    // 不明なカテゴリーIDを収集
    final unknownCategoryIds = <int>{};
    for (final entry in salaryEntries) {
      if (entry.year == year && !categories.any((cat) => cat.id == entry.categoryId)) {
        unknownCategoryIds.add(entry.categoryId);
      }
    }

    // 不明なカテゴリーを追加
    final allCategories = List<Category>.from(categories);
    for (final unknownId in unknownCategoryIds) {
      allCategories.add(Category(
        id: unknownId,
        name: '不明',
        color: 0xFFCCCCCC, // 月別画面と同じグレー色
        icon: 'help',
        createdAt: DateTime.now(),
      ));
    }

    // 月 × カテゴリー 金額テーブルを 0 初期化
    final monthlyData = <int, Map<int, double>>{
      for (var m = 1; m <= 12; m++)
        m: {for (final c in allCategories) c.id: 0.0},
    };

    // 入力データを加算
    for (final e in salaryEntries) {
      if (e.year == year) {
        monthlyData[e.month]![e.categoryId] =
            (monthlyData[e.month]![e.categoryId] ?? 0) + e.amount;
      }
    }

    // 12 ヶ月ぶん棒グループを生成
    return List.generate(12, (index) {
      final month = index + 1;
      final catTotals = monthlyData[month]!;              // {categoryId: amount}

      final total = catTotals.values.fold<double>(0, (s, a) => s + a);
      if (total == 0) {
        return BarChartGroupData(
          x: index, 
          barRods: [
            BarChartRodData(
              toY: 0,
              width: 10,
              color: Colors.transparent,
            ),
          ],
        );  // 透明な棒でスペース確保
      }

      // 金額降順で並べ替え（大きい金額が下側）
      final sortedCats = allCategories.toList()
        ..sort((a, b) => (catTotals[b.id]!).compareTo(catTotals[a.id]!));

      // ==== ★ 積み上げセグメントを作る ★ ====
      final stackItems = <BarChartRodStackItem>[];
      double fromY = 0;               // ← 自前で開始位置を持つ

      for (final cat in sortedCats) {
        final amount = catTotals[cat.id]!;
        if (amount == 0) continue;

        stackItems.add(
          BarChartRodStackItem(
            fromY,
            fromY + amount,
            Color(cat.color),
          ),
        );
        fromY += amount;
      }

      // ==== ★ 1 本だけ barRods を渡す ★ ====
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            rodStackItems: stackItems,
            width: 10,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  Widget _buildLegend(List<Category> categories) {
    return Wrap(
      spacing: 8.0, // 横の間隔
      runSpacing: 8.0, // 縦の間隔
      children: categories.map((category) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Color(category.color),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            category.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  double _getMaxY(List<BarChartGroupData> chartData) {
    double maxY = 0;
    for (final group in chartData) {
      for (final rod in group.barRods) {
        if (rod.toY > maxY) {
          maxY = rod.toY;
        }
      }
    }
    
    if (maxY == 0) return 100000;
    
    // 最高金額に基づいて適切な最大値を設定
    double maxValue;
    if (maxY <= 100000) { // 10万円以下
      maxValue = 100000;
    } else if (maxY <= 200000) { // 10万円から20万円
      maxValue = 200000;
    } else if (maxY <= 300000) { // 20万円から30万円
      maxValue = 300000;
    } else { // 30万円以降
      maxValue = (maxY / 100000).ceil() * 100000; // 10万円単位で切り上げ
    }
    
    return maxValue;
  }
} 