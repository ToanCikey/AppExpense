import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/repositories/category_repository.dart';
import 'package:doancuoiky/utils/enum_type.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<Map<String, dynamic>> reportByDay(DateTime day) async {
    DateTime startOfDayVN = DateTime(day.year, day.month, day.day, 0, 0, 0);
    DateTime endOfDayVN = startOfDayVN
        .add(Duration(days: 1))
        .subtract(Duration(seconds: 1));

    int startEpoch = startOfDayVN.millisecondsSinceEpoch;
    int endEpoch = endOfDayVN.millisecondsSinceEpoch;

    double totalIncome = 0;
    double totalExpense = 0;

    try {
      QuerySnapshot transactions =
          await _firestore
              .collection("transactions")
              .where("created_at", isGreaterThanOrEqualTo: startEpoch)
              .where("created_at", isLessThanOrEqualTo: endEpoch)
              .get();

      for (var doc in transactions.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double? amount =
            (data["amount"] is num)
                ? (data["amount"] as num).toDouble()
                : num.tryParse(data["amount"].toString())?.toDouble();
        if (amount == null) continue;

        Categories? cate = await _categoryRepository.getCategoryById(
          data["category_id"] ?? "",
        );
        if (cate?.type == CategoryType.income) {
          totalIncome += amount;
        } else {
          totalExpense += amount;
        }
      }
    } catch (e, stackTrace) {
      debugPrint("🔥 Lỗi khi lấy báo cáo ngày: $e");
      debugPrint(stackTrace.toString());
    }

    return {"total_income": totalIncome, "total_expense": totalExpense};
  }
}
