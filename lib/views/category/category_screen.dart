import 'package:doancuoiky/providers/category_provider.dart'
    show CategoryProvider;
import 'package:doancuoiky/views/category/create_category_form.dart';
import 'package:doancuoiky/views/category/expense_category.dart';
import 'package:doancuoiky/views/category/income_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      print("fetchCategories() đã chạy xong!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Danh mục",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          bottom: TabBar(
            tabs: [Tab(text: "Thu nhập"), Tab(text: "Chi tiêu")],
            indicatorColor: Colors.black,
          ),
        ),
        body: Consumer<CategoryProvider>(
          builder: (context, cateProvider, child) {
            if (cateProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                cateProvider.incomeCategories.isEmpty
                    ? Center(child: Text("Không có danh mục thu nhập"))
                    : IncomeCategory(categories: cateProvider.incomeCategories),

                cateProvider.expenseCategories.isEmpty
                    ? Center(child: Text("Không có danh mục chi tiêu"))
                    : ExpenseCategory(
                      categories: cateProvider.expenseCategories,
                    ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateCategoryForm()),
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
