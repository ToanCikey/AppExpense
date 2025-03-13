import 'package:doancuoiky/providers/transaction_provider.dart';
import 'package:doancuoiky/views/transaction/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:doancuoiky/utils/enum_type.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchTransactions();
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tranProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Giao dịch",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (transactionProvider.transactions.isEmpty) {
            return Center(child: Text("Không có giao dịch nào"));
          }
          return ListView.builder(
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              final category = transactionProvider.getCategoryById(
                transaction.category_id,
              );

              final categoryName = category?.name ?? "Không xác định";
              final isIncome = category?.type == CategoryType.income;
              final formattedAmount = NumberFormat(
                "#,###",
                "vi_VN",
              ).format(transaction.amount);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onLongPress: () {
                    tranProvider.deleteTransaction(transaction.id, context);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TransactionForm(
                              categories: tranProvider.categories,
                              transaction: transaction,
                            ),
                      ),
                    );
                  },

                  child: ListTile(
                    leading: Icon(
                      isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isIncome ? Colors.green : Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat(
                        'dd/MM/yyyy',
                      ).format(transaction.created_at ?? DateTime.now()),
                      style: TextStyle(color: Colors.grey[600]),
                    ),

                    trailing: Text(
                      "${isIncome ? '+' : '-'} $formattedAmount VNĐ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final categories = tranProvider.categories;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionForm(categories: categories),
            ),
          );
        },
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(Icons.add),
      ),
    );
  }
}
