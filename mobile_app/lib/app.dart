import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'features/patients/patients_screen.dart';
import 'features/medications/medications_screen.dart';
import 'features/medications/add_medication_screen.dart';
import 'features/schedules/schedules_screen.dart';
import 'features/reminders/reminders_screen.dart';
import 'theme/app_theme.dart';

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedTrack OSS',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/patients': (context) => const PatientsScreen(),
        '/medications': (context) => const MedicationsScreen(),
        '/add_medication': (context) => const AddMedicationScreen(),
        '/schedules': (context) => const SchedulesScreen(),
        '/reminders': (context) => const RemindersScreen(),
      },
    );
  }
}
