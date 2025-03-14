import 'package:doancuoiky/services/report_service.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _reportData;
  Map<String, dynamic>? get reportData => _reportData;

  final ReportService _reportService = ReportService();

  Future<void> fetchReportByDay(DateTime day) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reportData = await _reportService.reportByDay(day);
    } catch (e) {
      _reportData = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
