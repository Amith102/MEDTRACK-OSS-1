import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/patient.dart';
import '../../services/consult_report_service.dart';

class ConsultReportScreen extends StatefulWidget {
  final Patient patient;
  static const String route = '/consult_report';

  const ConsultReportScreen({super.key, required this.patient});

  @override
  State<ConsultReportScreen> createState() => _ConsultReportScreenState();
}

class _ConsultReportScreenState extends State<ConsultReportScreen> {
  final _reportService = ConsultReportService();
  int _selectedDaysFilter = 30; // Default view is last 30 days
  late String _generatedReport;

  @override
  void initState() {
    super.initState();
    _generateReportText();
  }

  void _generateReportText() {
    setState(() {
      _generatedReport = _reportService.generateReport(widget.patient, days: _selectedDaysFilter);
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedReport));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Text('Report copied to clipboard!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Consult Report'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Header String
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.date_range, color: Colors.teal),
                const SizedBox(width: 8),
                const Text('Timeframe:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedDaysFilter,
                    items: const [
                      DropdownMenuItem(value: 7, child: Text("Last 7 Days")),
                      DropdownMenuItem(value: 30, child: Text("Last 30 Days")),
                      DropdownMenuItem(value: 90, child: Text("Last 3 Months")),
                      DropdownMenuItem(value: 365, child: Text("All Time (1 Yr)")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDaysFilter = value;
                          _generateReportText();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _generatedReport,
                    style: TextStyle(
                      fontFamily: 'Courier', // Monospace for standard medical report feel
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _copyToClipboard,
        icon: const Icon(Icons.copy),
        label: const Text("Copy Report", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
