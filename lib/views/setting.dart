import 'package:doancuoiky/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Setting extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  Setting({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cài đặt", style: TextStyle(fontSize: 25)),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user!.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : AssetImage("assets/default_avatar.png")
                              as ImageProvider,
                ),
                SizedBox(height: 16),
                Text(
                  " ${user!.displayName ?? ""}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        authProvider.logout(context);
                      },
                      child: Text("Đăng xuất"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
