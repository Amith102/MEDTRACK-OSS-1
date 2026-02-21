import 'package:flutter/material.dart';

class ScheduleEntry {
  final String medication;
  final String dosage;
  final String time;
  final String patient;
  final String status;
  final Color statusColor;
  final String icon;

  ScheduleEntry({
    required this.medication,
    required this.dosage,
    required this.time,
    required this.patient,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}
