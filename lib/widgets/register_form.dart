import 'package:doancuoiky/utils/custom_input.dart';
import 'package:doancuoiky/utils/custom_input_password.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passWordController;
  final TextEditingController confirmPassWordController;
  final VoidCallback onRegister;
  final VoidCallback onLoginNavigate;
  final bool isLoading;
  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passWordController,
    required this.confirmPassWordController,
    required this.onRegister,
    required this.onLoginNavigate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          controller: emailController,
          label: "Email",
          hint: "Nhập Email",
        ),
        SizedBox(height: 10),
        CustomInputPassword(
          controller: passWordController,
          label: "Mật Khẩu",
          hint: "Nhập mật khẩu",
        ),
        SizedBox(height: 10),
        CustomInputPassword(
          controller: confirmPassWordController,
          label: "Nhập Lại Mật Khẩu",
          hint: "Nhập mật khẩu",
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade400,
            minimumSize: Size(200, 50),
          ),
          onPressed: isLoading ? null : onRegister,
          child: Text(
            "Đăng Ký",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: isLoading ? null : onLoginNavigate,
          child: Text("Đã có tài khoản? Đăng nhập"),
        ),
      ],
    );
  }
}
