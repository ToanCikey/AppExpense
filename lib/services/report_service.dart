import 'package:doancuoiky/repositories/report_repository.dart';
import 'package:doancuoiky/utils/custom_toast.dart';
import 'package:flutter/foundation.dart';

class ReportService {
  final ReportRepository _reportRepository = ReportRepository();

  Future<Map<String, dynamic>> reportByDay(DateTime day, String userId) async {
    DateTime now = DateTime.now();

    if (day.isAfter(now)) {
      CustomToast.showError("Không thể báo cáo ngày trong tương lai!");
    }
    if (day.year < 2020) {
      CustomToast.showError("Chỉ hỗ trợ báo cáo từ năm 2020 trở đi.");
    }

    try {
      return await _reportRepository.reportByDay(day, userId);
    } catch (e, stackTrace) {
      CustomToast.showError("Lỗi khi lấy báo cáo ngày");
      debugPrint(stackTrace.toString());
      return {"total_income": 0, "total_expense": 0};
    }
  }

  Future<Map<String, dynamic>> reportByMonth(
    DateTime month,
    String userId,
  ) async {
    DateTime now = DateTime.now();

    if (month.isAfter(now)) {
      CustomToast.showError("Không thể báo cáo tháng trong tương lai!");
      return {"total_income": 0, "total_expense": 0};
    }
    if (month.year < 2020) {
      CustomToast.showError("Chỉ hỗ trợ báo cáo từ năm 2020 trở đi.");
      return {"total_income": 0, "total_expense": 0};
    }

    try {
      return await _reportRepository.reportByMonth(month, userId);
    } catch (e, stackTrace) {
      CustomToast.showError("Lỗi khi lấy báo cáo tháng");
      debugPrint(stackTrace.toString());
      return {"total_income": 0, "total_expense": 0};
    }
  }
}
