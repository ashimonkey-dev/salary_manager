import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/category_provider.dart';
import '../../core/constants.dart';
import '../../core/utils/icon_utils.dart';

class AddCategoryDialog extends HookConsumerWidget {
  const AddCategoryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final selectedColorIndex = useState(0);
    final selectedIconIndex = useState(0);
    final isFormValid = useState(false);

    // テキストの変更を監視してボタンの活性化状態を更新
    useEffect(() {
      void updateFormValid() {
        isFormValid.value = nameController.text.trim().isNotEmpty;
      }
      
      nameController.addListener(updateFormValid);
      return () => nameController.removeListener(updateFormValid);
    }, [nameController]);

    return AlertDialog(
      title: const Text('給与種別追加'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 名称入力
            TextField(
              controller: nameController,
              maxLength: 30,
              decoration: const InputDecoration(
                labelText: '給与種別名',
                border: OutlineInputBorder(),
                counterText: '', // 文字数カウンターを非表示
              ),
            ),
            const SizedBox(height: 16),
            // 色選択
            const Text(
              '色を選択',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.colorPresets.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => selectedColorIndex.value = index,
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppConstants.colorPresets[index],
                        shape: BoxShape.circle,
                        border: selectedColorIndex.value == index
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // アイコン選択
            const Text(
              'アイコンを選択',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.iconPresets.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => selectedIconIndex.value = index,
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: selectedIconIndex.value == index
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: selectedIconIndex.value == index
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Icon(
                        IconUtils.getIconData(AppConstants.iconPresets[index]),
                        color: selectedIconIndex.value == index
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: isFormValid.value
              ? () async {
                  await ref.read(categoryProvider.notifier).addCategory(
                        nameController.text.trim(),
                        AppConstants.colorPresets[selectedColorIndex.value].value,
                        AppConstants.iconPresets[selectedIconIndex.value],
                      );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('給与種別を追加しました')),
                    );
                  }
                }
              : null,
          child: const Text('追加'),
        ),
      ],
    );
  }


} 