import 'package:doancuoiky/views/category/category_screen.dart';
import 'package:doancuoiky/views/report_screen.dart';
import 'package:doancuoiky/views/setting.dart';
import 'package:doancuoiky/views/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ReportScreen(),
    CategoryScreen(),
    TransactionScreen(),
    Setting(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Thống kê'),
          NavigationDestination(icon: Icon(Icons.category), label: 'Danh mục'),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            label: 'Giao dịch',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
