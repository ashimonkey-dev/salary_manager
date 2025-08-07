import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/category_provider.dart';
import '../providers/salary_provider.dart';
import '../providers/home_page_provider.dart';
import '../widgets/monthly_salary_chart.dart';
import '../widgets/salary_entry_list.dart';
import 'add_salary_page.dart';
import '../../core/constants.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = useState(DateTime.now());
    // 2020年1月から翌々年12月まで（現在月を中心に配置）
    final startDate = DateTime(2020, 1);
    final endDate = DateTime(DateTime.now().year + 2, 12);
    final totalMonths = endDate.difference(startDate).inDays ~/ 30;
    final pageController = ref.watch(homePageControllerProvider);

    final categoriesAsync = ref.watch(categoryProvider);
    final monthlySalaryAsync = ref.watch(
      monthlySalaryProvider((year: currentDate.value.year, month: currentDate.value.month))
    );

    useEffect(() {
      void listener() {
        final page = pageController.page?.round() ?? 0;
        final newDate = startDate.add(Duration(days: page * 30));
        currentDate.value = newDate;
      }
      
      pageController.addListener(listener);
      return () => pageController.removeListener(listener);
    }, [pageController]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // ヘッダー背景を白に
        centerTitle: true, // タイトルを中央に配置
        title: Row(
          mainAxisSize: MainAxisSize.min, // 必要最小限のサイズに
          children: [
            // 前月ボタン
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black),
              onPressed: () {
                final currentPage = pageController.page?.round() ?? 0;
                if (currentPage > 0) {
                  pageController.animateToPage(
                    currentPage - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
            // 年月表示
            Text(
              '${currentDate.value.year}年${currentDate.value.month}月',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black, // タイトル色を黒に
              ),
            ),
            // 翌月ボタン
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.black),
              onPressed: () {
                final currentPage = pageController.page?.round() ?? 0;
                if (currentPage < totalMonths - 1) {
                  pageController.animateToPage(
                    currentPage + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSalaryPage(
                    year: currentDate.value.year,
                    month: currentDate.value.month,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: totalMonths,
        itemBuilder: (context, pageIndex) {
          // 2020年1月から順次表示
          final pageDate = startDate.add(Duration(days: pageIndex * 30));
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // 月次チャート
                MonthlySalaryChart(
                  year: pageDate.year,
                  month: pageDate.month,
                ),
                // 明細リスト
                SalaryEntryList(
                  year: pageDate.year,
                  month: pageDate.month,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 