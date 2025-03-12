import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final UserRepository _user = UserRepository();

  Future<void> saveUser(Users user) async {
    try {
      await _user.saveUser(user);
    } catch (e) {
      print("Lưu user thất bại: $e");
    }
  }

  Future<Users?> getUser(String id) async {
    try {
      return await _user.getUser(id);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await getUser(user.uid).then((userData) => userData?.id);
    }
    return null;
  }
}
