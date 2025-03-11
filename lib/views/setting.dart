import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/providers/auth_provider.dart';
import 'package:doancuoiky/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? id;

  @override
  void initState() {
    super.initState();
    id = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cài đặt", style: TextStyle(fontSize: 25)),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<Users?>(
          future:
              id != null ? UserRepository().getUser(id!) : Future.value(null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Không tìm thấy thông tin người dùng"));
            }

            Users user = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          user.img != null
                              ? NetworkImage(user.img!)
                              : AssetImage("assets/default_avatar.png")
                                  as ImageProvider,
                    ),
                    SizedBox(height: 16),
                    Text(
                      user.name ?? "Không có tên",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            );
          },
        ),
      ),
    );
  }
}
