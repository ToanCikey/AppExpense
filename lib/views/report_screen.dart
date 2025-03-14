import 'package:doancuoiky/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedType = "Ngày";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport() {
    Provider.of<ReportProvider>(
      context,
      listen: false,
    ).fetchReportByDay(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final reportData = reportProvider.reportData;
    print(reportData);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thống kê chi tiêu",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedType,
                    items:
                        ["Ngày", "Tháng", "Năm"]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                      });
                    },
                    underline: const SizedBox(),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                        _fetchReport();
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          selectedType == "Ngày"
                              ? DateFormat("dd/MM/yyyy").format(selectedDate)
                              : selectedType == "Tháng"
                              ? DateFormat("MM/yyyy").format(selectedDate)
                              : selectedDate.year.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            reportProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reportData != null
                ? Column(
                  children: [
                    _buildStatCard(
                      title: "Thu nhập",
                      value: reportData["total_income"] ?? 0,
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    _buildStatCard(
                      title: "Chi tiêu",
                      value: reportData["total_expense"] ?? 0,
                      icon: Icons.money_off,
                      color: Colors.red,
                    ),
                  ],
                )
                : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Chưa có dữ liệu thống kê",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            "${NumberFormat("#,###", "vi_VN").format(value)} VNĐ",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
