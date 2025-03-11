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
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown',
      email: map['email'] ?? 'no-email@example.com',
      img: map['img'] ?? '',
      created_at:
          map['created_at'] != null
              ? (map['created_at'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'img': img,
      'created_at':
          created_at != null
              ? Timestamp.fromDate(created_at!)
              : FieldValue.serverTimestamp(),
    };
  }
}
