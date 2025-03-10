import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(Users user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<Users?> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user?.uid).get();

    if (userDoc.exists) {
      return Users.fromMap(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
