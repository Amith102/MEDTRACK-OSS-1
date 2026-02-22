import 'emergency_profile.dart';

class Dependent {
  final String id;
  final String name;
  final String relation;
  final EmergencyProfile? emergencyProfile;

  Dependent({
    required this.id,
    required this.name,
    required this.relation,
    this.emergencyProfile,
  });

  factory Dependent.fromJson(Map<String, dynamic> json) {
    return Dependent(
      id: json['id'] as String,
      name: json['name'] as String,
      relation: json['relation'] as String,
      emergencyProfile: json['emergencyProfile'] != null 
          ? EmergencyProfile.fromJson(json['emergencyProfile']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'emergencyProfile': emergencyProfile?.toJson(),
    };
  }
}
