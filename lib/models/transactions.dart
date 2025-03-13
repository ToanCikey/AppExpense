import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String id;
  final String category_id;
  final double amount;
  final String note;
  final DateTime? created_at;

  Transactions({
    required this.id,
    required this.category_id,
    required this.amount,
    required this.note,
    required this.created_at,
  });

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'] ?? '',
      category_id: map['category_id'],
      amount: map['amount'],
      note: map['note'],
      created_at:
          map['created_at'] != null
              ? (map['created_at'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': category_id,
      'amount': amount,
      'note': note,
      'created_at':
          created_at != null
              ? Timestamp.fromDate(created_at!)
              : FieldValue.serverTimestamp(),
    };
  }
}
