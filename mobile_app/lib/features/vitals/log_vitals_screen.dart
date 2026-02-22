import 'package:flutter/material.dart';
import '../../models/vital_sign.dart';

class LogVitalsScreen extends StatefulWidget {
  final String dependentId;
  static const String route = '/log_vitals';

  const LogVitalsScreen({super.key, required this.dependentId});

  @override
  State<LogVitalsScreen> createState() => _LogVitalsScreenState();
}

class _LogVitalsScreenState extends State<LogVitalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  String _selectedMetric = 'Blood Pressure';
  String _selectedUnit = 'mmHg';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  static const List<String> metrics = [
    'Blood Pressure',
    'Heart Rate',
    'Weight',
    'Blood Sugar',
    'Temperature',
    'Oxygen Saturation'
  ];

  final Map<String, List<String>> unitMap = {
    'Blood Pressure': ['mmHg'],
    'Heart Rate': ['bpm'],
    'Weight': ['lbs', 'kg'],
    'Blood Sugar': ['mg/dL', 'mmol/L'],
    'Temperature': ['°F', '°C'],
    'Oxygen Saturation': ['%'],
  };

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _saveLog() {
    if (_formKey.currentState!.validate()) {
      final vital = VitalSign(
        metricName: _selectedMetric,
        value: _valueController.text.trim(),
        unit: _selectedUnit,
        timestamp: _selectedDate,
      );
      Navigator.pop(context, vital);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Vital Sign'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.monitor_heart, color: Colors.teal[700], size: 32),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Track biometric data to visualize long-term health trends over time.',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                const Text('Select Metric', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedMetric,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: metrics.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMetric = newValue!;
                      _selectedUnit = unitMap[_selectedMetric]!.first;
                      _valueController.clear();
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                const Text('Measurement Value', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _valueController,
                        keyboardType: _selectedMetric == 'Blood Pressure' 
                            ? TextInputType.text // For '120/80'
                            : const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: _selectedMetric == 'Blood Pressure' ? 'e.g., 120/80' : 'e.g., 98.6',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        items: unitMap[_selectedMetric]!.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedUnit = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDateTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} at ${_selectedTime.format(context)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.teal),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
