import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';

import '../../models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseListListener,
      builder: (BuildContext context, List<CategoryModel> newExpenseList,
          Widget? _) {
        return ListView.separated(
            itemBuilder: (context, index) {
              final category = newExpenseList[index];
              return Card(
                child: ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        CategoryDB.instance.deleteCategory(category.id);
                      },
                      icon: Icon(Icons.delete)),
                  title: Text(category.name),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                ],
              );
            },
            itemCount: newExpenseList.length);
      },
    );
  }
}
