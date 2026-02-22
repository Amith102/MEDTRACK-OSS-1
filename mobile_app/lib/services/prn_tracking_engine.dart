import '../models/medication.dart';
import '../models/medication_log.dart';

class PrnStatus {
  final bool isAllowed;
  final Duration? timeUntilNextDose;
  final String? denialReason;

  PrnStatus({
    required this.isAllowed,
    this.timeUntilNextDose,
    this.denialReason,
  });

  factory PrnStatus.allowed() => PrnStatus(isAllowed: true);
  
  factory PrnStatus.denied(String reason, {Duration? timeUntil}) {
    return PrnStatus(
      isAllowed: false,
      denialReason: reason,
      timeUntilNextDose: timeUntil,
    );
  }
}

class PrnTrackingEngine {
  /// Evaluates whether a PRN medication is safe to take based on the provided history.
  static PrnStatus checkPrnDoseAllowed(Medication prnMed, List<MedicationLog> history) {
    if (!prnMed.isPRN) {
       return PrnStatus.allowed(); // Not a PRN med, rules don't apply here
    }

    final now = DateTime.now();
    final rolling24HoursCutoff = now.subtract(const Duration(hours: 24));

    // Filter history for THIS medication, only instances where it was actually taken
    final relevantHistory = history
        .where((log) => log.medicationName == prnMed.name && log.status == 'Taken')
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime)); // Newest first

    if (relevantHistory.isEmpty) {
      return PrnStatus.allowed(); // Never taken, safe to take
    }

    // 1. Check Max Doses per 24 Hours
    if (prnMed.maxDosesPer24Hours != null) {
      final dosesInLast24Hours = relevantHistory
          .where((log) => log.scheduledTime.isAfter(rolling24HoursCutoff))
          .length;

      if (dosesInLast24Hours >= prnMed.maxDosesPer24Hours!) {
        // Find the oldest dose in the rolling 24h window to calculate when it drops off
        final rollingDoses = relevantHistory
            .where((log) => log.scheduledTime.isAfter(rolling24HoursCutoff))
            .toList(); // Already sorted newest first
            
        final oldestDoseInWindow = rollingDoses.last;
        final timeUntilDropOff = oldestDoseInWindow.scheduledTime.add(const Duration(hours: 24)).difference(now);
        
        return PrnStatus.denied(
          "24-Hour limit reached (${prnMed.maxDosesPer24Hours} doses).",
          timeUntil: timeUntilDropOff,
        );
      }
    }

    // 2. Check Minimum Time Gap Between Doses
    if (prnMed.minHoursBetweenDoses != null) {
      final lastDoseTime = relevantHistory.first.scheduledTime;
      final requiredGap = Duration(hours: prnMed.minHoursBetweenDoses!);
      final actualGap = now.difference(lastDoseTime);

      if (actualGap < requiredGap) {
        final timeRemaining = requiredGap - actualGap;
        return PrnStatus.denied(
          "Too soon. Minimum gap is ${prnMed.minHoursBetweenDoses} hours.",
          timeUntil: timeRemaining,
        );
      }
    }

    // Safely passed all checks
    return PrnStatus.allowed();
  }
}
