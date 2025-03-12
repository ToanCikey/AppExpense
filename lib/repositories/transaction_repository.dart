import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/models/transactions.dart';
import 'package:doancuoiky/repositories/category_repository.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<void> saveTransaction(Transactions transaction) async {
    await _firestore
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await _firestore.collection('transactions').doc(id).delete();
  }

  Future<List<Transactions>> listTransactions(String userId) async {
    List<Categories> categoryIds = await _categoryRepository.listCategoryByName(
      userId,
    );
    if (categoryIds.isEmpty) return [];
    QuerySnapshot snapshot =
        await _firestore
            .collection('transactions')
            .where('category_id', whereIn: categoryIds)
            .get();

    return snapshot.docs
        .map((doc) => Transactions.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    await _firestore.collection('transactions').doc(id).update(data);
  }
}
