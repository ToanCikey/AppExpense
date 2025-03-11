import 'package:flutter/material.dart';

class ExpenseCategory extends StatefulWidget {
  const ExpenseCategory({super.key});

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  @override
  Widget build(BuildContext context) {
    return Text("expense");
  }
}
