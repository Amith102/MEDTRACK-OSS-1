import 'emergency_profile.dart';
import 'audit_log_entry.dart';

class Dependent {
  final String id;
  final String name;
  final String relation;
  final EmergencyProfile? emergencyProfile;
  final List<AuditLogEntry> activityFeed;

  Dependent({
    required this.id,
    required this.name,
    required this.relation,
    this.emergencyProfile,
    this.activityFeed = const [],
  });

  factory Dependent.fromJson(Map<String, dynamic> json) {
    return Dependent(
      id: json['id'] as String,
      name: json['name'] as String,
      relation: json['relation'] as String,
      emergencyProfile: json['emergencyProfile'] != null 
          ? EmergencyProfile.fromJson(json['emergencyProfile']) 
          : null,
      activityFeed: (json['activityFeed'] as List<dynamic>?)
              ?.map((e) => AuditLogEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'emergencyProfile': emergencyProfile?.toJson(),
      'activityFeed': activityFeed.map((e) => e.toJson()).toList(),
    };
  }
}
