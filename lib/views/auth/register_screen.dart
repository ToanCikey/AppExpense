import 'package:doancuoiky/providers/auth_provider.dart';
import 'package:doancuoiky/views/auth/login_screen.dart';
import 'package:doancuoiky/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmPassWordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 180),
                    const Text(
                      "Đăng Ký Tài Khoản",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RegisterForm(
                      emailController: emailController,
                      passWordController: passWordController,
                      confirmPassWordController: confirmPassWordController,
                      isLoading: authProvider.isLoading,
                      onRegister: () {
                        authProvider.register(
                          emailController.text,
                          passWordController.text,
                          confirmPassWordController.text,
                          context,
                        );
                      },
                      onLoginNavigate: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (authProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
