import 'package:doancuoiky/utils/enum_type.dart';

class Categories {
  final String id;
  final String user_id;
  final String name;
  final CategoryType type;

  Categories({
    required this.id,
    required this.user_id,
    required this.name,
    required this.type,
  });

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'],
      user_id: map['user_id'],
      name: map['name'],
      type: CategoryType.values.byName(map['type'] ?? 'income'),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'user_id': user_id, 'name': name, 'type': type.name};
  }

  @override
  String toString() {
    return 'Categories(id: $id, user_id: $user_id, name: $name, type: ${type.name})';
  }
}
