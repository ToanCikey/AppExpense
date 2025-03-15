import 'package:doancuoiky/utils/custom_input.dart';
import 'package:doancuoiky/utils/custom_input_password.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passWordController;
  final VoidCallback onLogin;
  final VoidCallback onRegisterNavigate;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passWordController,
    required this.onLogin,
    required this.onRegisterNavigate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          controller: emailController,
          label: "Email",
          hint: "Nhập email",
        ),
        SizedBox(height: 10),
        CustomInputPassword(
          controller: passWordController,
          label: "Mật Khẩu",
          hint: "Nhập mật khẩu",
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              elevation: 2,
            ),
            onPressed: isLoading ? null : onLogin,
            child: const Text(
              "Đăng Nhập",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        TextButton(
          onPressed: isLoading ? null : onRegisterNavigate,
          child: Text("Chưa có tài khoản? Đăng ký"),
        ),
      ],
    );
  }
}
