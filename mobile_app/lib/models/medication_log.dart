import 'package:uuid/uuid.dart';

class MedicationLog {
  final String id;
  final String medicationName;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final String status; // "Taken" or "Skipped"
  final String? notes;
  final String? administeredBy;

  MedicationLog({
    String? id,
    required this.medicationName,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.notes,
    this.administeredBy,
  }) : id = id ?? const Uuid().v4();

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      id: json['id'] as String,
      medicationName: json['medicationName'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      takenTime: json['takenTime'] != null
          ? DateTime.parse(json['takenTime'] as String)
          : null,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      administeredBy: json['administeredBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicationName': medicationName,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime?.toIso8601String(),
      'status': status,
      'notes': notes,
      'administeredBy': administeredBy,
    };
  }
}
