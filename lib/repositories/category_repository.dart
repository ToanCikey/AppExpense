import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/categories.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Categories?> getCategoryById(String id, String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('categories').doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['user_id'] == userId) {
        return Categories.fromMap(data);
      }
    }
    return null;
  }

  Future<void> saveCategory(Categories category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .set(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }

  Future<List<Categories>> listCategory(String userId, String type) async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('categories')
            .where('user_id', isEqualTo: userId)
            .where('type', isEqualTo: type)
            .get();

    return snapshot.docs
        .map((doc) => Categories.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _firestore.collection('categories').doc(id).update(data);
  }

  Future<List<Categories>> listCategoryByName(String userId) async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('categories')
            .where('user_id', isEqualTo: userId)
            .get();

    return snapshot.docs
        .map((doc) => Categories.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
