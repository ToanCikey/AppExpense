import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/repositories/auth_repository.dart';
import 'package:doancuoiky/repositories/user_repository.dart';
import 'package:doancuoiky/utils/toasthelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final AuthRepository _auth = AuthRepository();
  final UserRepository _user = UserRepository();

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
    User? user = await _auth.register(email, password);
    if (user != null) {
      Users newUser = Users(
        id: user.uid,
        name: "Uknow",
        email: email,
        img: user.photoURL ?? '',
        created_at: DateTime.now(),
      );

      await _user.saveUser(newUser);
      ToastHelper.showSuccess(context, "Đăng ký thành công");
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      ToastHelper.showWarning(context, "Đăng ký thất bại");
      return;
    }
  }

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
    User? user = await _auth.login(email, password);
    if (user != null) {
      ToastHelper.showSuccess(context, "Đăng nhập thành công");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ToastHelper.showWarning(context, "Email hoặc PassWord không đúng !");
    }
  }

  Future<User?> signInWithGoogle() async {
    User? user = await _auth.signInWithGoogle();
    if (user != null) {
      Users? existingUser = await _user.getUser(user.uid);
      if (existingUser == null) {
        Users newUser = Users(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          img: user.photoURL ?? '',
          created_at: DateTime.now(),
        );
        await _user.saveUser(newUser);
      }
    }
    return user;
  }

  Future<void> signOut() async {
    return _auth.signOut();
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
