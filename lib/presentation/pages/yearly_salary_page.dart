import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/category_provider.dart';
import '../providers/salary_provider.dart';
import '../providers/yearly_page_provider.dart';
import '../widgets/yearly_salary_chart.dart';
import '../../core/constants.dart';

class YearlySalaryPage extends HookConsumerWidget {
  const YearlySalaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startYear = 2020;
    final endYear = DateTime.now().year + 2;
    final totalYears = endYear - startYear + 1;
    final currentYearIndex = DateTime.now().year - startYear;
    
    final currentYear = useState(DateTime.now().year);
    final pageController = ref.watch(yearlyPageControllerProvider);

    useEffect(() {
      pageController.addListener(() {
        final page = pageController.page?.round() ?? currentYearIndex;
        final newYear = startYear + page;
        currentYear.value = newYear;
      });
      return null;
    }, [pageController]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // ヘッダー背景を白に
        title: Text(
          '${currentYear.value}年',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black, // タイトル色を黒に
          ),
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: totalYears,
        onPageChanged: (page) {
          final newYear = startYear + page;
          currentYear.value = newYear;
        },
        itemBuilder: (context, index) {
          final year = startYear + index;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: YearlySalaryChart(year: year),
          );
        },
      ),
    );
  }
} 