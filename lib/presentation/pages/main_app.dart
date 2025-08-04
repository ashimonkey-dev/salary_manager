import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'home_page.dart';
import 'yearly_salary_page.dart';
import 'category_management_page.dart';
import '../providers/home_page_provider.dart';
import '../providers/yearly_page_provider.dart';

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);

    final pages = [
      const HomePage(),
      const YearlySalaryPage(),
      const CategoryManagementPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white, // 全体背景を真っ白に
      body: IndexedStack(
        index: currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -2), // 上部にシャドウ
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white, // 白背景
          selectedItemColor: Colors.black, // 選択時の色（黒）
          unselectedItemColor: Colors.grey, // 非選択時の色（グレー）
          currentIndex: currentIndex.value,
        onTap: (index) {
          currentIndex.value = index;
          // ホームタブを押した時に当月に戻る
          if (index == 0) {
            ref.read(homePageControllerProvider.notifier).goToCurrentMonth();
          }
          // 年別タブを押した時に現在の年に戻る
          if (index == 1) {
            ref.read(yearlyPageControllerProvider.notifier).goToCurrentYear();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '年別給与',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '給与種別',
          ),
        ],
        ),
      ),
    );
  }
} 