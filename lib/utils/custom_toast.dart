import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';

class CustomToast {
  static void showSuccess(String message) {
    _showToast(message, Colors.green, Icons.check_circle);
  }

  static void showError(String message) {
    _showToast(message, Colors.red, Icons.error);
  }

  static void showWarning(String message) {
    _showToast(message, Colors.orange, Icons.warning);
  }

  static void showInfo(String message) {
    _showToast(message, Colors.blue, Icons.info);
  }

  static void _showToast(String message, Color bgColor, IconData icon) {
    showToastWidget(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
      position: ToastPosition.top,
    );
  }
}
