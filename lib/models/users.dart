import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String name;
  final String email;
  final String img;
  final DateTime? created_at;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.img,
    this.created_at,
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['uid'] ?? '',
      name: map['displayName'],
      email: map['email'],
      img: map['photoURL'],
      created_at:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'displayName': name,
      'email': email,
      'photoURL': img,
      'createdAt':
          created_at != null
              ? Timestamp.fromDate(created_at!)
              : FieldValue.serverTimestamp(),
    };
  }
}
