import 'dart:ui';

class Medication {
  int id;
  String name;
  String dosage;
  String frequency;
  List<bool> frequencyWeekly;
  String purpose;
  String icon;
  Color color;
  String nextDue;
  bool isActive;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.frequencyWeekly,
    required this.purpose,
    required this.icon,
    required this.color,
    required this.nextDue,
    required this.isActive,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as int,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      frequencyWeekly: List<bool>.from(json['frequencyWeekly']),
      purpose: json['purpose'] as String,
      icon: json['icon'] as String,
      color: Color(json['color'] as int),
      nextDue: json['nextDue'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'frequencyWeekly': frequencyWeekly,
      'purpose': purpose,
      'icon': icon,
      'color': color.value,
      'nextDue': nextDue,
      'isActive': isActive,
    };
  }
}
