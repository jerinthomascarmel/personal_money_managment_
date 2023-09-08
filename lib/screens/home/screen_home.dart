import 'package:flutter/material.dart';
import 'package:personal_money_management_app/screens/category/category_add_popup.dart';
import 'package:personal_money_management_app/screens/category/screen_category.dart';
import 'package:personal_money_management_app/screens/home/widgets/bottom_nav_widget.dart';
import 'package:personal_money_management_app/screens/transactions/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  static ValueNotifier selectedIndex = ValueNotifier(0);

  final _pages = [ScreenTransaction(), ScreenCategory()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MONEY MANAGER"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        titleTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBar: const MMBottomNavigation(),
      body: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, updatedIndex, child) {
          return _pages[updatedIndex];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedIndex.value == 0) {
            print('transaction here');
          } else {
            showCategoryAddPopup(context);
            // final _sample = CategoryModel(
            //     id: DateTime.now().millisecondsSinceEpoch.toString(),
            //     name: 'name',
            //     type: CategoryType.expense);
            // await CategoryDB().insertCategory(_sample);
            // print('category here');
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
