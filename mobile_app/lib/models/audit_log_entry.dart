class AuditLogEntry {
  final String id;
  final DateTime timestamp;
  final String action;
  final String caregiverName;
  final String type; // 'medication', 'note', 'symptom'

  AuditLogEntry({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.caregiverName,
    required this.type,
  });

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: json['action'] as String,
      caregiverName: json['caregiverName'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'action': action,
      'caregiverName': caregiverName,
      'type': type,
    };
  }
}
