import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/providers/auth_provider.dart' show AuthProvider;
import 'package:doancuoiky/widgets/user_detail_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetail extends StatefulWidget {
  final Users user;
  const UserDetail({super.key, required this.user});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  var nameController = TextEditingController();
  var idController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    idController = TextEditingController(text: widget.user.id);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông tin cá nhân",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: UserDetailForm(
                  nameController: nameController,
                  emailController: emailController,
                  idController: idController,
                  onSave: () {
                    authProvider.saveUserInfo(
                      nameController.text,
                      idController.text,
                      context,
                    );
                  },
                  onSaveImg: () {},
                  user: widget.user,
                  isLoading: authProvider.isLoading,
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
