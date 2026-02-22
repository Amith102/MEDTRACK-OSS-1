class EmergencyProfile {
  final String bloodType;
  final List<String> allergies;
  final String emergencyContactName;
  final String emergencyContactPhone;

  EmergencyProfile({
    required this.bloodType,
    required this.allergies,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  });

  factory EmergencyProfile.fromJson(Map<String, dynamic> json) {
    return EmergencyProfile(
      bloodType: json['bloodType'] as String,
      allergies: List<String>.from(json['allergies']),
      emergencyContactName: json['emergencyContactName'] as String,
      emergencyContactPhone: json['emergencyContactPhone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'allergies': allergies,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
    };
  }
}
