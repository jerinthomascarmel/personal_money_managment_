import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/db/transactions/transaction_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.RefreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (context, newList, child) {
        return Card(
          child: ListView.separated(
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final _value = newList[index];
                return Slidable(
                  key: Key(_value.id!),
                  startActionPane:
                      ActionPane(motion: ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        TransactionDB.instance.deleteTransaction(_value.id!);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ]),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        parseDate(_value.date),
                        textAlign: TextAlign.center,
                        style: _value.type == CategoryType.expense
                            ? TextStyle(color: Colors.red)
                            : TextStyle(color: Colors.green),
                      ),
                      radius: 50,
                    ),
                    title: Text('${_value.amount}'),
                    subtitle: Text('${_value.category.name}'),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: newList.length),
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final splitedDate = _date.split(' ');
    return '${splitedDate.last} \n ${splitedDate.first}';
  }
}
