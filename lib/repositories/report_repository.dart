import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/reports.dart';
import 'package:flutter/foundation.dart';
import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/repositories/category_repository.dart';
import 'package:doancuoiky/utils/enum_type.dart';
import 'package:uuid/uuid.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CategoryRepository _categoryRepository = CategoryRepository();
  final Uuid uuid = Uuid();

  Future<Map<String, dynamic>> reportByDay(DateTime day, String userId) async {
    DateTime startOfDayVN = DateTime(day.year, day.month, day.day, 0, 0, 0);
    DateTime endOfDayVN = startOfDayVN
        .add(Duration(days: 1))
        .subtract(Duration(seconds: 1));

    int startEpoch = startOfDayVN.millisecondsSinceEpoch;
    int endEpoch = endOfDayVN.millisecondsSinceEpoch;

    double totalIncome = 0;
    double totalExpense = 0;

    try {
      QuerySnapshot existingReport =
          await _firestore
              .collection("reports")
              .where("user_id", isEqualTo: userId)
              .where("period", isEqualTo: startEpoch)
              .get();

      String? reportId;
      if (existingReport.docs.isNotEmpty) {
        reportId = existingReport.docs.first.id;
      }

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

      if (reportId != null) {
        await _firestore.collection("reports").doc(reportId).update({
          "total_income": totalIncome,
          "total_expense": totalExpense,
        });
      } else {
        Reports report = Reports(
          id: uuid.v4(),
          user_id: userId,
          period: startOfDayVN,
          total_income: totalIncome,
          total_expense: totalExpense,
        );
        await saveReports(report);
      }
    } catch (e, stackTrace) {
      debugPrint("🔥 Lỗi khi lấy báo cáo ngày: $e");
      debugPrint(stackTrace.toString());
    }

    return {"total_income": totalIncome, "total_expense": totalExpense};
  }

  Future<void> saveReports(Reports report) async {
    await _firestore.collection('reports').doc(report.id).set(report.toMap());
  }
}
