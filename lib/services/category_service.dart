import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository _category = CategoryRepository();

  Future<void> saveCategory(Categories category) async {
    try {
      await _category.saveCategory(category);
    } catch (e) {
      throw Exception("Lưu danh mục thất bại: ${e.toString()}");
    }
  }

  Future<void> deleteCategory(String? id) async {
    if (id == null || id.isEmpty) {
      throw Exception("Không có id hợp lệ!");
    }
    try {
      await _category.deleteCategory(id);
    } catch (e) {
      throw Exception("Xóa danh mục thất bại: ${e.toString()}");
    }
  }

  Future<List<Categories>> listCategory() async {
    try {
      return await _category.listCategory();
    } catch (e) {
      throw Exception("Lấy danh mục thất bại: ${e.toString()}");
    }
  }

  Future<void> updateCategory(String? id, Map<String, dynamic> data) async {
    if (id == null || id.isEmpty) {
      throw Exception("Không có id hợp lệ!");
    }
    try {
      await _category.updateCategory(id, data);
    } catch (e) {
      throw Exception("Sửa danh mục thất bại: ${e.toString()}");
    }
  }
}
