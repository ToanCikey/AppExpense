import 'package:doancuoiky/repositories/auth_repository.dart';
import 'package:doancuoiky/utils/toasthelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final AuthRepository _auth = AuthRepository();

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    String? emailError = validateEmail(email);
    String? passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      ToastHelper.showError(context, emailError ?? passwordError!);
      return;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));
    User? user = await _auth.login(email, password);

    _isLoading = false;
    notifyListeners();

    if (user != null) {
      ToastHelper.showSuccess(context, "Đăng nhập thành công");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ToastHelper.showWarning(context, "Email hoặc PassWord không đúng !");
    }
  }

  Future<void> register(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    String? emailError = validateEmail(email);
    String? passwordError = validatePassword(password);
    String? passwordConfirmError = validatePassword(confirmPassword);
    if (emailError != null ||
        passwordError != null ||
        passwordConfirmError != null) {
      ToastHelper.showError(
        context,
        emailError ?? passwordError ?? passwordConfirmError!,
      );
      return;
    }
    if (password != confirmPassword) {
      ToastHelper.showWarning(context, "Mật khẩu không trùng khớp");
      return;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    User? user = await _auth.register(email, password);

    _isLoading = false;
    notifyListeners();

    if (user != null) {
      ToastHelper.showSuccess(context, "Đăng ký thành công");
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      ToastHelper.showWarning(context, "Đăng ký thất bại");
    }
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Mật khẩu không được để trống";
    }
    if (value.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự";
    }
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email không được để trống";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return "Email không hợp lệ";
    }
    return null;
  }
}
