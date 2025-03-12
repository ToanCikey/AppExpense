import 'package:doancuoiky/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/utils/toasthelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final AuthService _auth = AuthService();

  Future<void> saveUserInfo(
    String name,
    String id,
    BuildContext context,
  ) async {
    if (name.trim().isEmpty) {
      ToastHelper.showError(context, "Tên không được để trống!");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'name': name.trim(),
      });

      ToastHelper.showSuccess(context, "Cập nhật thành công");
    } catch (e) {
      ToastHelper.showError(context, "Cập nhật thất bại: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));
    await _auth.login(email, password, context);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    await _auth.register(email, password, confirmPassword, context);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    User? user = await _auth.signInWithGoogle();

    _isLoading = false;
    notifyListeners();

    if (user != null) {
      // ToastHelper.showSuccess(context, "Đăng nhập thành công");
      Navigator.pushReplacementNamed(context, "/home");
    }
    // } else {
    //   ToastHelper.showWarning(context, "Email hoặc PassWord không đúng !");
    // }
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    await _auth.signOut();
    ToastHelper.showSuccess(context, "Đăng xuất thành công");

    _isLoading = false;
    notifyListeners();

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}
