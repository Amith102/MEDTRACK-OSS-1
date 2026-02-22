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
  String? rxNumber;
  int? refillsRemaining;
  int? refillsRemaining;
  int pillsRemaining;
  bool isPRN;
  int? minHoursBetweenDoses;
  int? maxDosesPer24Hours;

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
    this.rxNumber,
    this.refillsRemaining,
    this.pillsRemaining = 0,
    this.isPRN = false,
    this.minHoursBetweenDoses,
    this.maxDosesPer24Hours,
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
      rxNumber: json['rxNumber'] as String?,
      refillsRemaining: json['refillsRemaining'] as int?,
      pillsRemaining: json['pillsRemaining'] as int? ?? 0,
      isPRN: json['isPRN'] as bool? ?? false,
      minHoursBetweenDoses: json['minHoursBetweenDoses'] as int?,
      maxDosesPer24Hours: json['maxDosesPer24Hours'] as int?,
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
      'rxNumber': rxNumber,
      'refillsRemaining': refillsRemaining,
      'pillsRemaining': pillsRemaining,
      'isPRN': isPRN,
      'minHoursBetweenDoses': minHoursBetweenDoses,
      'maxDosesPer24Hours': maxDosesPer24Hours,
    };
  }
}
