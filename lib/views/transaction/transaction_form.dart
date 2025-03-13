import 'package:doancuoiky/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final List<Categories> categories;
  const TransactionForm({super.key, required this.categories});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

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
    String value = _amountController.text.replaceAll(RegExp(r'\D'), '');
    if (value.isNotEmpty) {
      setState(() {
        _amountController.text = currencyFormat.format(int.parse(value));
        _amountController.selection = TextSelection.collapsed(
          offset: _amountController.text.length - 4,
        ); // Giữ con trỏ đúng vị trí
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Danh sách danh mục: ${widget.categories.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thêm giao dịch",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                    DateFormat('EEEE, dd MMM yyyy', 'vi').format(_selectedDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Số tiền",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập số tiền",
                ),
                onChanged: (value) => _formatAmount(),
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
              ),
              SizedBox(height: 16),
              Text(
                "Ghi chú",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _noteController,
                maxLength: 100,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nhập ghi chú (tùy chọn)",
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
                  onPressed: () {},
                  child: const Text(
                    "Lưu giao dịch",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
