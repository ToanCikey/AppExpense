import 'package:flutter/material.dart';
import 'package:doancuoiky/models/users.dart';

class UserDetailForm extends StatelessWidget {
  final Users user;
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onSave;
  final VoidCallback onSaveImg;
  final bool isLoading;

  const UserDetailForm({
    super.key,
    required this.user,
    required this.nameController,
    required this.onSave,
    required this.isLoading,
    required this.onSaveImg,
    required this.idController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      // ignore: unnecessary_null_comparison
                      user.img != null
                          ? NetworkImage(user.img)
                          : const AssetImage("assets/default_avatar.png")
                              as ImageProvider,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onSaveImg,
                  child: const Text("Thay đổi ảnh"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: idController,
            decoration: const InputDecoration(labelText: "ID"),
            enabled: false,
          ),

          const SizedBox(height: 10),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Tên"),
          ),

          const SizedBox(height: 10),

          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
            enabled: false,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isLoading ? null : onSave,
              child: const Text(
                "Lưu thông tin",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
