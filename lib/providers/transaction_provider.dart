import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/models/transactions.dart';
import 'package:doancuoiky/services/category_service.dart';
import 'package:doancuoiky/services/transaction_service.dart';
import 'package:doancuoiky/services/user_service.dart';
import 'package:doancuoiky/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Transactions> _transactions = [];
  List<Categories> _categories = [];
  List<Transactions> get transactions => _transactions;
  List<Categories> get categories => _categories;
  final CategoryService _categoryService = CategoryService();
  final UserService _userService = UserService();
  final TransactionService _transactionService = TransactionService();
  final Uuid uuid = Uuid();

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
      print("Danh sách giao dịch: $_transactions");
    } catch (e) {
      _transactions = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Categories>> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    List<Categories> categoriesList = [];

    try {
      String? userId = await _userService.getID();
      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return [];
      }
      categoriesList = await _categoryService.listCategoryByName(userId);

      _categories = categoriesList;
    } catch (e) {
      print("Lỗi khi lấy danh mục: $e");
      categoriesList = [];
    }

    _isLoading = false;
    notifyListeners();
    return categoriesList;
  }

  Categories? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      debugPrint("Không tìm thấy danh mục có ID: $categoryId");
      return null;
    }
  }

  Future<void> addTransaction(
    DateTime datetime,
    double amount,
    String note,
    String category_id,
  ) async {
    _isLoading = true;
    notifyListeners();

    final newTransaction = Transactions(
      id: uuid.v4(),
      category_id: category_id,
      amount: amount,
      note: note,
      created_at: datetime,
    );
    try {
      await _transactionService.saveTransaction(newTransaction);
      _transactions = [..._transactions, newTransaction];
      notifyListeners();
    } catch (e) {
      CustomToast.showError(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(
    String transactionId,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Xác nhận xóa"),
            content: const Text("Bạn có muốn xóa giao dịch này không?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Hủy"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Chắc chắn"),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      try {
        await _transactionService.deleteTransaction(transactionId);
        await fetchTransactions();
      } catch (e) {
        CustomToast.showError(e.toString());
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTransaction(Transactions transaction) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _transactionService.updateTransaction(
        transaction.id,
        transaction.toMap(),
      );
      await fetchTransactions();
      notifyListeners();
    } catch (e) {
      CustomToast.showError(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }
}
