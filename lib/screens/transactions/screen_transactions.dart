import 'package:flutter/material.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  '12 \n dec',
                  textAlign: TextAlign.center,
                ),
                radius: 50,
              ),
              title: Text('10000'),
              subtitle: Text('travel $index'),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: 100),
    );
  }
}
