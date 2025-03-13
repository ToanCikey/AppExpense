import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/models/transactions.dart';
import 'package:doancuoiky/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TransactionForm extends StatefulWidget {
  Transactions? transaction;
  final List<Categories> categories;
  TransactionForm({super.key, required this.categories, this.transaction});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  final NumberFormat currencyFormat = NumberFormat("#,### VNĐ", "vi_VN");

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _formatAmount() {
    String value = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (value.isNotEmpty) {
      int amount = int.parse(value);
      String formattedText = NumberFormat("#,###", "vi_VN").format(amount);

      int cursorPosition = formattedText.length;

      setState(() {
        _amountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: cursorPosition),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _selectedDate = widget.transaction!.created_at!;
      _amountController.text = widget.transaction!.amount.toInt().toString();
      _formatAmount();
      _noteController.text = widget.transaction!.note;
      _selectedCategory = widget.transaction!.category_id;
    } else {
      _selectedCategory =
          widget.categories.isNotEmpty ? widget.categories.first.id : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Danh sách danh mục: ${widget.categories.length}");
    final tranProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm/Cập nhật Giao Dịch",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ngày",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat(
                        'EEEE, dd MMM yyyy',
                        'vi',
                      ).format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Số tiền",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nhập số tiền",
                    suffixText: "VNĐ",
                  ),
                  onChanged: (value) => _formatAmount(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Số tiền không được để trống";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                Text(
                  "Danh mục",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text("Chọn danh mục"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items:
                      widget.categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null) {
                      return "Vui lòng chọn danh mục";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  "Ghi chú",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _noteController,
                  maxLength: 100,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nhập ghi chú (tùy chọn)",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ghi chú không được để trống";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        double amount =
                            double.tryParse(
                              _amountController.text.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              ),
                            ) ??
                            0;

                        final transaction = Transactions(
                          id: widget.transaction?.id ?? '',
                          category_id: _selectedCategory!,
                          amount: amount,
                          note: _noteController.text.trim(),
                          created_at: _selectedDate,
                        );
                        if (widget.transaction == null) {
                          tranProvider.addTransaction(
                            transaction.created_at!,
                            transaction.amount,
                            transaction.note,
                            transaction.category_id,
                          );
                        } else {
                          tranProvider.updateTransaction(transaction);
                        }
                        Navigator.pop(context, true);
                      }
                    },
                    child: Text(
                      widget.transaction == null
                          ? "Thêm giao dịch"
                          : "Cập nhật giao dịch",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Quay lại",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
