import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/models/transactions.dart';
import 'package:doancuoiky/services/category_service.dart';
import 'package:doancuoiky/services/transaction_service.dart';
import 'package:doancuoiky/services/user_service.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Transactions> _transactions = [];
  List<Categories> _categories = [];
  List<Transactions> get transactions => _transactions;
  final CategoryService _categoryService = CategoryService();
  final UserService _userService = UserService();
  final TransactionService _transactionService = TransactionService();

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();
    try {
      String? userId = await _userService.getID();
      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      _transactions = await _transactionService.getAllTransactions(userId);
    } catch (e) {
      _transactions = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      String? userId = await _userService.getID();
      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      _categories = await _categoryService.listCategoryByName(userId);
    } catch (e) {
      _categories = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Categories getCategoryById(String categoryId) {
    return _categories.firstWhere(
      (category) => category.id == categoryId,
      orElse:
          () => throw Exception("Không tìm thấy danh mục có ID: $categoryId"),
    );
  }
}
