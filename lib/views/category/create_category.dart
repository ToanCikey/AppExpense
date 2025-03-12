import 'package:doancuoiky/providers/category_provider.dart'
    show CategoryProvider;
import 'package:doancuoiky/utils/enum_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCategoryForm extends StatefulWidget {
  const CreateCategoryForm({super.key});

  @override
  State<CreateCategoryForm> createState() => _CreateCategoryFormState();
}

class _CreateCategoryFormState extends State<CreateCategoryForm> {
  final nameController = TextEditingController();
  CategoryType selectedType = CategoryType.income;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Danh Mục", style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Tên danh mục"),
          ),
          DropdownButton<CategoryType>(
            value: selectedType,
            items: const [
              DropdownMenuItem(
                value: CategoryType.income,
                child: Text("Thu nhập"),
              ),
              DropdownMenuItem(
                value: CategoryType.expense,
                child: Text("Chi tiêu"),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedType = value;
                });
              }
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CategoryProvider>(
                context,
                listen: false,
              ).addCategory(nameController.text, selectedType, context);

              Navigator.pop(context);
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }
}
