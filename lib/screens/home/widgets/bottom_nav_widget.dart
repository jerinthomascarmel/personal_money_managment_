import 'package:flutter/material.dart';
import 'package:personal_money_management_app/screens/home/screen_home.dart';

class MMBottomNavigation extends StatelessWidget {
  const MMBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ScreenHome.selectedIndex,
        builder: (ctx, updated, child) {
          return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Transaction'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category')
            ],
            currentIndex: updated,
            onTap: (newIndex) {
              ScreenHome.selectedIndex.value = newIndex;
            },
          );
        });
  }
}
