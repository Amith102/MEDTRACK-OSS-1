import '../../models/patient.dart';

class ConsultReportService {
  /// Generates a structured Markdown report summarizing a patient's recent history.
  String generateReport(Patient patient, {int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final buffer = StringBuffer();

    // 1. Header Information
    buffer.writeln('# Medical Consult Report');
    buffer.writeln('**Patient Name:** ${patient.name}');
    buffer.writeln('**Report Generated:** ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('**Reporting Period:** Last $days Days');
    buffer.writeln('**Age:** ${patient.age} | **Gender:** ${patient.gender}');
    buffer.writeln('**Phone:** ${patient.phoneNumber}');
    buffer.writeln('\n---\n');

    // 2. Medication Adherence Summary
    buffer.writeln('## Medication Adherence');
    final recentMeds = patient.medicationLogs.where((log) => log.scheduledTime.isAfter(cutoffDate)).toList();
    if (recentMeds.isEmpty) {
      buffer.writeln('*No medication data logged in this period.*');
    } else {
      final takenCount = recentMeds.where((log) => log.status == 'Taken').length;
      final adherencePercent = ((takenCount / recentMeds.length) * 100).toStringAsFixed(1);
      buffer.writeln('- **Overall Adherence Rate:** $adherencePercent% ($takenCount/${recentMeds.length} doses taken)');
      
      // Group by medication for detailed breakdown
      final medsMap = <String, Map<String, int>>{};
      for (final log in recentMeds) {
        medsMap.putIfAbsent(log.medicationName, () => {'total': 0, 'taken': 0});
        medsMap[log.medicationName]!['total'] = medsMap[log.medicationName]!['total']! + 1;
        if (log.status == 'Taken') {
           medsMap[log.medicationName]!['taken'] = medsMap[log.medicationName]!['taken']! + 1;
        }
      }

      medsMap.forEach((medName, stats) {
        final rate = ((stats['taken']! / stats['total']!) * 100).toStringAsFixed(0);
        buffer.writeln('  - $medName: $rate% adherence');
      });
    }
    buffer.writeln('\n---\n');

    // 3. Symptom Log History
    buffer.writeln('## Symptom History');
    final recentSymptoms = patient.symptomLogs.where((log) {
       final logDate = DateTime.parse(log.date);
       return logDate.isAfter(cutoffDate);
    }).toList();

    if (recentSymptoms.isEmpty) {
      buffer.writeln('*No symptoms logged in this period.*');
    } else {
       // Sort newest first
       recentSymptoms.sort((a, b) => b.date.compareTo(a.date));
       
       for (final log in recentSymptoms) {
          final logDate = DateTime.parse(log.date);
          final dateStr = '${logDate.month}/${logDate.day} at ${logDate.hour}:${logDate.minute.toString().padLeft(2, '0')}';
          
          buffer.write('- **$dateStr — ${log.symptomName}** (Severity: ${log.severity}/10)');
          if (log.notes.isNotEmpty) {
             buffer.write(' *Notes: ${log.notes}*');
          }
          if (log.environment != null) {
             buffer.write(' [Context: Temp: ${log.environment!.temperature}, AQI: ${log.environment!.aqi}]');
          }
          buffer.writeln();
       }
    }
    buffer.writeln('\n---\n');

    // 4. Clinical Notes History
    buffer.writeln('## Selected Clinical Notes');
    final recentNotes = patient.notes.where((note) => note.date.isAfter(cutoffDate)).toList();
    if (recentNotes.isEmpty) {
      buffer.writeln('*No clinical notes logged in this period.*');
    } else {
       recentNotes.sort((a, b) => b.date.compareTo(a.date));
       for (final note in recentNotes) {
         final dateStr = '${note.date.month}/${note.date.day}/${note.date.year}';
         buffer.writeln('### $dateStr: ${note.title} (${note.category})');
         buffer.writeln('> ${note.content}\n');
       }
    }

    return buffer.toString();
  }
}
