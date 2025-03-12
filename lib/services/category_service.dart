import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/repositories/category_repository.dart';
import 'package:doancuoiky/utils/enum_type.dart';

class CategoryService {
  final CategoryRepository _category = CategoryRepository();

  Future<void> saveCategory(Categories category) async {
    try {
      await _category.saveCategory(category);
    } catch (e) {
      throw Exception("Lưu danh mục thất bại: ${e.toString()}");
    }
  }

  Future<void> deleteCategory(String id) async {
    if (id.isEmpty) {
      throw Exception("Không có id hợp lệ!");
    }
    try {
      await _category.deleteCategory(id);
    } catch (e) {
      throw Exception("Xóa danh mục thất bại: ${e.toString()}");
    }
  }

  Future<List<Categories>> getIncomeCategories(String userId) async {
    try {
      return await _category.listCategory(userId, CategoryType.income.name);
    } catch (e) {
      throw Exception("Lấy danh mục thất bại: ${e.toString()}");
    }
  }

  Future<List<Categories>> getExpenseCategories(String userId) async {
    try {
      return await _category.listCategory(userId, CategoryType.expense.name);
    } catch (e) {
      throw Exception("Lấy danh mục thất bại: ${e.toString()}");
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    if (id.isEmpty) {
      throw Exception("Không có id hợp lệ!");
    }
    try {
      await _category.updateCategory(id, data);
    } catch (e) {
      throw Exception("Sửa danh mục thất bại: ${e.toString()}");
    }
  }
}
