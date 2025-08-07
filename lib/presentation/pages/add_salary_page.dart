import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/category_provider.dart';
import '../providers/salary_provider.dart';
import '../../domain/models/category.dart';
import '../../core/utils/icon_utils.dart';

class AddSalaryPage extends HookConsumerWidget {
  final int year;
  final int month;

  const AddSalaryPage({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = useTextEditingController();
    final amountController = useTextEditingController();
    final selectedCategoryId = useState<int?>(null);
    final isFormValid = useState(false);
    final focusNode = useFocusNode();
    final categoriesAsync = ref.watch(categoryProvider);

    // フォームの有効性を監視
    useEffect(() {
      void updateFormValidity() {
        isFormValid.value = selectedCategoryId.value != null &&
            amountController.text.trim().isNotEmpty;
      }

      amountController.addListener(updateFormValidity);
      updateFormValidity(); // 初期状態
      return () => amountController.removeListener(updateFormValidity);
    }, [selectedCategoryId.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text('給与追加 - $year年$month月'),
      ),
      body: GestureDetector(
        onTap: () => focusNode.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ▼ カテゴリー選択
              categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '給与種別がありません。先に給与種別を作成してください。',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '給与種別',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          /// --- ドロップダウン ---
                          DropdownButtonFormField<int>(
                            value: selectedCategoryId.value,
                            isExpanded: true, // 横幅いっぱいに展開
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '給与種別を選択',
                            ),

                            // ▼ ドロップダウンメニュー（開いたときのアイテム）
                            items: categories.map((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Color(category.color),
                                      child: Icon(
                                        IconUtils.getIconData(category.icon),
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // メニュー側は flex を使わずそのまま
                                    Text(
                                      category.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            // ▼ 選択中表示（閉じているとき）
                            selectedItemBuilder: (context) {
                              return categories.map((category) {
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Color(category.color),
                                      child: Icon(
                                        IconUtils.getIconData(category.icon),
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        category.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },

                            onChanged: (value) {
                              selectedCategoryId.value = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('エラー: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ▼ 金額入力
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '金額',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                                             TextField(
                         controller: amountController,
                         focusNode: focusNode,
                         keyboardType: TextInputType.number,
                         inputFormatters: [
                           FilteringTextInputFormatter.digitsOnly, // 数字のみ
                           LengthLimitingTextInputFormatter(8), // 8桁まで（99,999,999円）
                         ],
                         decoration: const InputDecoration(
                           border: OutlineInputBorder(),
                           labelText: '金額を入力（0〜99,999,999円）',
                           suffixText: '円',
                         ),
                       ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ▼ 保存ボタン
              ElevatedButton(
                onPressed: isFormValid.value
                    ? () async {
                                                 final amount = double.tryParse(amountController.text);
                         if (amount == null || amount < 0 || amount > 99999999) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                               content: Text('金額は0円〜99,999,999円の範囲で入力してください'),
                             ),
                           );
                           return;
                         }

                        await ref.read(salaryProvider.notifier).addSalaryEntry(
                              selectedCategoryId.value!,
                              amount,
                              year,
                              month,
                            );
                        
                        // 月次データを更新
                        ref.invalidate(monthlySalaryProvider((year: year, month: month)));
                        
                        // 年次データを更新
                        ref.invalidate(yearlySalaryProvider(year));

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('給与を追加しました'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}