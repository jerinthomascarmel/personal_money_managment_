import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  static final Screen_add_Transaction = 'add_transaction';

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? _selectedDateTime;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Money Managment System',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(19),
        child: Column(
          children: [
            //purpose
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Purpose',
              ),
            ),
            //amount
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Amount'),
            ),
            SizedBox(
              height: 10,
            ),

            //calendar
            ElevatedButton.icon(
                onPressed: () async {
                  final _selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 30)),
                      lastDate: DateTime.now());

                  if (_selectedDate == null) {
                    return;
                  } else {
                    print(_selectedDate);
                    setState(() {
                      _selectedDateTime = _selectedDate;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text(_selectedDateTime == null
                    ? 'Add Date'
                    : _selectedDateTime.toString())),

            //category-radiobutton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryType = value;
                          _categoryID = null;
                        });
                      },
                    ),
                    Text('Income')
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryType = value;
                          _categoryID = null;
                        });
                      },
                    ),
                    Text('expense')
                  ],
                ),
              ],
            ),

            //dropdown button
            DropdownButton(
              value: _categoryID,
              hint: const Text('Select Category'),
              items: (_selectedCategoryType == CategoryType.expense
                      ? CategoryDB.instance.expenseListListener
                      : CategoryDB.instance.incomeListListener)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  child: Text(e.name),
                  value: e.id,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoryID = value;
                });
                print(value);
              },
            ),

            //submit button
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {},
              label: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
