import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/repositories/user_repository.dart';
import 'package:doancuoiky/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _auth = AuthService();
  final UserRepository _userRepo = UserRepository();

  Future<User?> register(String email, String password) async {
    User? user = await _auth.register(email, password);
    if (user != null) {
      Users newUser = Users(
        id: user.uid,
        name: "Uknow",
        email: email,
        img: user.photoURL ?? '',
        created_at: DateTime.now(),
      );

      await _userRepo.saveUser(newUser);
    }
    return user;
  }

  Future<User?> login(String email, String password) async {
    return _auth.login(email, password);
  }

  Future<User?> signInWithGoogle() async {
    User? user = await _auth.signInWithGoogle();
    if (user != null) {
      Users? existingUser = await _userRepo.getUser(user.uid);
      if (existingUser == null) {
        Users newUser = Users(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          img: user.photoURL ?? '',
          created_at: DateTime.now(),
        );
        await _userRepo.saveUser(newUser);
      }
    }
    return user;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
