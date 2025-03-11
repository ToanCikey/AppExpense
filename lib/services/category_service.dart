import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/categories.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCategory(Categories category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .set(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }

  Future<List<Categories>> listCategory() async {
    QuerySnapshot snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => Categories.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _firestore.collection('categories').doc(id).update(data);
  }
}
