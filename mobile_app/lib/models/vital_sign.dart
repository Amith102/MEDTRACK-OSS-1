import 'package:uuid/uuid.dart';

class VitalSign {
  final String id;
  final String metricName; // e.g., "Heart Rate", "Blood Pressure", "Weight"
  final String value; // Represented as String (e.g., "120/80" or "85")
  final String unit; // e.g., "bpm", "mmHg", "lbs"
  final DateTime timestamp;

  VitalSign({
    String? id,
    required this.metricName,
    required this.value,
    required this.unit,
    required this.timestamp,
  }) : id = id ?? const Uuid().v4();

  factory VitalSign.fromJson(Map<String, dynamic> json) {
    return VitalSign(
      id: json['id'] as String,
      metricName: json['metricName'] as String,
      value: json['value'] as String,
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metricName': metricName,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Helper method for numeric graphing capabilities
  double? get numericValue {
    // Basic catch for raw doubles (like weight: 155.2)
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed;

    // For blood pressure (e.g. 120/80), we might just return the systolic for basic graphing
    if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.isNotEmpty) {
        return double.tryParse(parts[0].trim());
      }
    }
    
    return null;
  }
}
