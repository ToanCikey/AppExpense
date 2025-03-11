import 'package:doancuoiky/views/category/expense_category.dart';
import 'package:doancuoiky/views/category/income_category.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Danh Mục",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            tabs: [Tab(text: "Thu nhập"), Tab(text: "Chi tiêu")],
            indicatorColor: Colors.black,
          ),
        ),
        body: TabBarView(children: [IncomeCategory(), ExpenseCategory()]),
      ),
    );
  }
}
