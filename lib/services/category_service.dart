import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/repositories/category_repository.dart';
import 'package:doancuoiky/utils/custom_toast.dart';
import 'package:doancuoiky/utils/enum_type.dart';

class CategoryService {
  final CategoryRepository _category = CategoryRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveCategory(Categories category) async {
    try {
      await _category.saveCategory(category);
      CustomToast.showSuccess("Thêm danh mục thành công");
    } catch (e) {
      CustomToast.showError(e.toString());
    }
  }

  Future<void> deleteCategory(String id) async {
    QuerySnapshot transactions =
        await _firestore
            .collection("transactions")
            .where("category_id", isEqualTo: id)
            .get();

    if (transactions.docs.isNotEmpty) {
      CustomToast.showError(
        "Không thể xóa danh mục này vì có giao dịch liên quan.",
      );
      return;
    }
    if (id.isEmpty) {
      CustomToast.showError("Không có id hợp lệ!");
      return;
    }
    try {
      await _category.deleteCategory(id);
      CustomToast.showSuccess("Xóa danh mục thành công");
    } catch (e) {
      CustomToast.showError(e.toString());
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
      CustomToast.showError("Không có id hợp lệ!");
      return;
    }
    try {
      await _category.updateCategory(id, data);
      CustomToast.showSuccess("Cập nhật danh mục thành công");
    } catch (e) {
      CustomToast.showSuccess("Cập nhật danh mục thất bại");
    }
  }

  Future<List<Categories>> listCategoryByName(String userId) async {
    if (userId.isEmpty) {
      throw Exception("Không có id hợp lệ!");
    }
    try {
      return await _category.listCategoryByName(userId);
    } catch (e) {
      throw Exception("Lấy danh mục thất bại: ${e.toString()}");
    }
  }
}
