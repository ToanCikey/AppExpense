import 'package:doancuoiky/services/report_service.dart';
import 'package:doancuoiky/services/user_service.dart';
import 'package:flutter/material.dart';

class ReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _reportData;
  Map<String, dynamic>? get reportData => _reportData;
  final UserService _userService = UserService();
  final ReportService _reportService = ReportService();

  Future<void> fetchReportByDay(DateTime day) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? userId = await _userService.getID();
      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      _reportData = await _reportService.reportByDay(day, userId);
    } catch (e) {
      _reportData = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
