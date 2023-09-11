import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String CategoryID);
}

class CategoryDB implements CategoryDbFunctions {
  //singleton object
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeListListener = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseListListener = ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    // await _categoryDB.add(value);
    await _categoryDB.put(value.id, value);
    RefreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> RefreshUI() async {
    final List<CategoryModel> list = await getCategories();

    expenseListListener.value.clear();
    incomeListListener.value.clear();

    await Future.forEach(list, (CategoryModel category) {
      if (category.type == CategoryType.expense) {
        expenseListListener.value.add(category);
      } else {
        incomeListListener.value.add(category);
      }
    });

    expenseListListener.notifyListeners();
    incomeListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String CategoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(CategoryID);
    RefreshUI();
  }
}
