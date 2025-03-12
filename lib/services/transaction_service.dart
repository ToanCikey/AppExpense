import 'package:doancuoiky/models/transactions.dart';
import 'package:doancuoiky/repositories/transaction_repository.dart';
import 'package:doancuoiky/utils/custom_toast.dart';

class TransactionService {
  final TransactionRepository _repository = TransactionRepository();

  Future<void> saveTransaction(Transactions transaction) async {
    try {
      await _repository.saveTransaction(transaction);
      CustomToast.showSuccess("Thêm giao dịch thành công");
    } catch (e) {
      CustomToast.showError("Thêm giao dịch thất bại");
    }
  }

  Future<void> deleteTransaction(String id) async {
    if (id.isEmpty) {
      CustomToast.showError("Không có id hợp lệ!");
    }
    try {
      await _repository.deleteTransaction(id);
      CustomToast.showSuccess("Xóa giao dịch thành công");
    } catch (e) {
      CustomToast.showError("Xóa giao dịch thất bại");
    }
  }

  Future<List<Transactions>> getAllTransactions(String userId) async {
    return await _repository.listTransactions(userId);
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    if (id.isEmpty) {
      CustomToast.showError("Không có id hợp lệ!");
    }
    try {
      await _repository.updateTransaction(id, data);
    } catch (e) {
      CustomToast.showError("Cập nhật giao dịch thất bại");
    }
  }
}
