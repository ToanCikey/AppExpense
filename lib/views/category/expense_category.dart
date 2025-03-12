import 'package:doancuoiky/models/categories.dart';
import 'package:doancuoiky/providers/category_provider.dart';
import 'package:doancuoiky/views/category/create_category_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExpenseCategory extends StatefulWidget {
  List<Categories> categories;
  ExpenseCategory({super.key, required this.categories});

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        return GestureDetector(
          onLongPress: () {
            Provider.of<CategoryProvider>(
              context,
              listen: false,
            ).deleteCategory(category.id, context);
          },
          onTap: () {
            final result = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateCategoryForm(category: category),
              ),
            );

            if (result == true) {
              Provider.of<CategoryProvider>(
                context,
                listen: false,
              ).fetchCategories();
            }
          },
          child: ListTile(
            title: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
