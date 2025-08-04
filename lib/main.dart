import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/pages/main_app.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/salary_repository.dart';
import 'presentation/providers/category_provider.dart';
import 'presentation/providers/salary_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hiveの初期化
  await Hive.initFlutter();
  
  // リポジトリの初期化
  final categoryRepository = CategoryRepository();
  final salaryRepository = SalaryRepository();
  
  await categoryRepository.initialize();
  await salaryRepository.initialize();
  
  // CategoryRepositoryにSalaryRepositoryを設定
  categoryRepository.setSalaryRepository(salaryRepository);
  
  runApp(
    ProviderScope(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(categoryRepository),
        salaryRepositoryProvider.overrideWithValue(salaryRepository),
      ],
      child: const SalaryManagerApp(),
    ),
  );
}

class SalaryManagerApp extends StatelessWidget {
  const SalaryManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '給与管理',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // 全体の背景色を真っ白に
      ),
      home: const MainApp(),
    );
  }
}
