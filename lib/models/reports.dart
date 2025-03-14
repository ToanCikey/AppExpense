import 'package:cloud_firestore/cloud_firestore.dart';

class Reports {
  final String id;
  final String user_id;
  final DateTime period;
  final double total_income;
  final double total_expense;
  final DateTime? created_at;

  Reports({
    required this.id,
    required this.user_id,
    required this.period,
    required this.total_income,
    required this.total_expense,
    this.created_at,
  });

  factory Reports.fromMap(Map<String, dynamic> map) {
    return Reports(
      id: map['id'] ?? '',
      user_id: map['user_id'],
      period:
          map['period'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['period'])
              : DateTime.now(),
      total_income: map['total_income'],
      total_expense: map['total_expense'],
      created_at:
          map['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'period': period.millisecondsSinceEpoch,
      'total_income': total_income,
      'total_expense': total_expense,
      'created_at':
          created_at?.millisecondsSinceEpoch ?? FieldValue.serverTimestamp(),
    };
  }
}
