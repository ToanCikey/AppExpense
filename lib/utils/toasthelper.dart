import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastHelper {
  static void showSuccess(BuildContext context, String message) {
    MotionToast.success(
      title: const Text(
        "Success",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      borderRadius: 8.0,
      width: 350,
      height: 60,
      toastDuration: const Duration(seconds: 2),
    ).show(context);
  }

  static void showError(BuildContext context, String message) {
    MotionToast.error(
      title: const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
      description: Text(message),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      borderRadius: 8.0,
      width: 350,
      height: 60,
      toastDuration: const Duration(seconds: 2),
    ).show(context);
  }

  static void showWarning(BuildContext context, String message) {
    MotionToast.warning(
      title: const Text(
        "Warning",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(message),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      borderRadius: 8.0,
      width: 350,
      height: 60,
      toastDuration: const Duration(seconds: 2),
    ).show(context);
  }

  static void showInfo(BuildContext context, String message) {
    MotionToast.info(
      title: const Text("Info", style: TextStyle(fontWeight: FontWeight.bold)),
      description: Text(message),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      borderRadius: 8.0,
      width: 350,
      height: 60,
      toastDuration: const Duration(seconds: 2),
    ).show(context);
  }
}
