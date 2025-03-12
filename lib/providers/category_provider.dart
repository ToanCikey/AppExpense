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

  Future<void> addCategory(
    String name,
    CategoryType type,
    BuildContext context,
  ) async {
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
      print("Thêm danh mục thành công: ${newCategory.name}");
    } catch (e) {
      print("Thêm danh mục thất bại: $e");
    }
  }
}
