import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final nameEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: nameEditingController,
              decoration: const InputDecoration(
                hintText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const RadioButton(title: 'Income', type: CategoryType.income),
          const RadioButton(title: 'Expense', type: CategoryType.expense),
          ElevatedButton(
              onPressed: () {
                final name = nameEditingController.text;
                if (name.isEmpty) {
                  return;
                }
                final model = CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    type: selectedCategoryNotifier.value);

                CategoryDB().insertCategory(model);
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'))
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          builder: (context, newType, child) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newType,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
          valueListenable: selectedCategoryNotifier,
        ),
        Text(title)
      ],
    );
  }
}
