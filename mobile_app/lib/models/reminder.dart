import 'package:flutter/material.dart';

class Reminder {
  final int id;
  final String medication;
  final String patient;
  final String scheduledTime;
  final String type;
  final bool isEnabled;
  final int notificationCount;
  final String icon;

  Reminder({
    required this.id,
    required this.medication,
    required this.patient,
    required this.scheduledTime,
    required this.type,
    this.isEnabled = true,
    required this.notificationCount,
    this.icon = '🔔',
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as int,
      medication: json['medication'] as String,
      patient: json['patient'] as String,
      scheduledTime: json['scheduledTime'] as String,
      type: json['type'] as String,
      isEnabled: json['isEnabled'] as bool,
      notificationCount: json['notificationCount'] as int,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication': medication,
      'patient': patient,
      'scheduledTime': scheduledTime,
      'type': type,
      'isEnabled': isEnabled,
      'notificationCount': notificationCount,
      'icon': icon,
    };
  }
}
