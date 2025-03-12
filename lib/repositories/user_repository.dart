import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/users.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(Users user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<Users?> getUser(String id) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(id).get();

    if (userDoc.exists) {
      return Users.fromMap(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<String> getID(Users user) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.id).get();
    return userDoc.id;
  }
}
