import 'package:doancuoiky/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _auth = AuthService();

  Future<User?> register(String email, String password) async {
    return _auth.register(email, password);
  }

  Future<User?> login(String email, String password) async {
    return _auth.login(email, password);
  }

  Future<User?> signInWithGoogle() async {
    return _auth.signInWithGoogle();
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
