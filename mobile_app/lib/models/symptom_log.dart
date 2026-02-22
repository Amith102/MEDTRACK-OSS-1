import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'environmental_context.dart';

class SymptomLog {
  final String id;
  final String date;
  final String symptomName; // Retained based on constructor/fromJson/toJson
  final int severity; // 1-10
  final List<String> triggers;
  final String notes;
  final EnvironmentalContext? environment;

  SymptomLog({
    String? id,
    required this.date,
    required this.symptomName,
    required this.severity,
    this.triggers = const [],
    this.notes = '',
    this.environment,
  }) : id = id ?? const Uuid().v4();

  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    return SymptomLog(
      id: json['id'] as String,
      date: json['date'] as String,
      symptomName: json['symptomName'] as String,
      severity: json['severity'] as int,
      triggers: List<String>.from(json['triggers'] ?? []),
      notes: json['notes'] as String? ?? '',
      environment: json['environment'] != null
          ? EnvironmentalContext.fromJson(json['environment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'symptomName': symptomName,
      'severity': severity,
      'triggers': triggers,
      'notes': notes,
      'environment': environment?.toJson(),
    };
  }
}
