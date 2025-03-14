import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/services/category_service.dart';
import 'package:doancuoiky/services/user_service.dart';
import 'package:doancuoiky/utils/enum_type.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final UserService _userService = UserService();
  final Uuid uuid = Uuid();
  bool _isLoading = false;
  List<Categories> _incomeCategories = [];
  List<Categories> _expenseCategories = [];

  bool get isLoading => _isLoading;
  List<Categories> get incomeCategories => _incomeCategories;
  List<Categories> get expenseCategories => _expenseCategories;

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

      _incomeCategories = await _categoryService.getIncomeCategories(userId);
      _expenseCategories = await _categoryService.getExpenseCategories(userId);

      print("Fetched income categories: $_incomeCategories");
      print("Fetched expense categories: $_expenseCategories");
    } catch (e) {
      print("Lỗi khi lấy danh mục: $e");
      _incomeCategories = [];
      _expenseCategories = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(String name, CategoryType type) async {
    _isLoading = true;
    notifyListeners();
    String? id = await _userService.getID();
    if (id == null) {
      print("Không tìm thấy user ID");
      return;
    }
    final newCategory = Categories(
      id: uuid.v4(),
      user_id: id,
      name: name,
      type: type,
    );

    try {
      await _categoryService.saveCategory(newCategory);

      if (type == CategoryType.income) {
        _incomeCategories = [..._incomeCategories, newCategory];
      } else {
        _expenseCategories = [..._expenseCategories, newCategory];
      }

      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Xác nhận xóa"),
            content: const Text("Bạn có muốn xóa danh mục này không?"),
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
        await _categoryService.deleteCategory(categoryId);
        await fetchCategories();
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCategory(Categories category) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _categoryService.updateCategory(category.id, category.toMap());

      _incomeCategories.removeWhere((cat) => cat.id == category.id);
      _expenseCategories.removeWhere((cat) => cat.id == category.id);

      if (category.type == CategoryType.income) {
        _incomeCategories.add(category);
      } else {
        _expenseCategories.add(category);
      }

      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }
}
