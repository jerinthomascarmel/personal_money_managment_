import 'package:flutter/material.dart';
import 'package:personal_money_management_app/db/category/category_db.dart';
import 'package:personal_money_management_app/db/transactions/transaction_db.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';
import 'package:personal_money_management_app/models/transactions/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  static const Screen_add_Transaction = 'add_transaction';

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? _selectedDateTime;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final TextEditingController _purpose = TextEditingController();
  final TextEditingController _amount = TextEditingController();

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
        padding: const EdgeInsets.all(19),
        child: Column(
          children: [
            //purpose
            TextFormField(
              controller: _purpose,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Purpose',
              ),
            ),
            //amount
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), hintText: 'Amount'),
            ),
            const SizedBox(
              height: 10,
            ),

            //calendar
            ElevatedButton.icon(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 30)),
                      lastDate: DateTime.now());

                  if (selectedDate == null) {
                    return;
                  } else {
                    // print(selectedDate);
                    setState(() {
                      _selectedDateTime = selectedDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
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
                    const Text('Income')
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
                    const Text('expense')
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
                  onTap: () {
                    _selectedCategoryModel = e;
                  },
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoryID = value;
                });
                // print(value);
              },
            ),

            //submit button
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () => AddTransaction(),
              label: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> AddTransaction() async {
    final _purposeText = _purpose.text;
    final _amountText = _amount.text;
    // ignore: unnecessary_null_comparison
    if (_purpose == null) {
      return;
    }

    // ignore: unnecessary_null_comparison
    if (_amount == null) {
      return;
    }

    if (_selectedCategoryModel == null) {
      return;
    }

    if (_selectedDateTime == null) {
      return;
    }

    if (_selectedCategoryModel == null) {
      return;
    }

    final parsedAmount = double.tryParse(_amountText);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
      purpose: _purposeText,
      amount: parsedAmount,
      date: _selectedDateTime!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransactionDB(model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
