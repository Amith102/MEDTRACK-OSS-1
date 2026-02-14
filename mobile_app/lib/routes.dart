import 'package:flutter/material.dart';
import 'package:mobile_app/navigation/widgets/main_screen.dart';
import 'package:mobile_app/features/home/home_screen.dart';
import 'package:mobile_app/features/medications/add_medication_screen.dart';
import 'package:mobile_app/features/medications/medications_screen.dart';
import 'package:mobile_app/features/patients/add_patient_screen.dart';
import 'package:mobile_app/features/patients/patients_screen.dart';
import 'package:mobile_app/features/patients/widgets/add_patient_note_view.dart';
import 'package:mobile_app/features/patients/widgets/patient_details_view.dart';
import 'package:mobile_app/features/reminders/add_reminder_screen.dart';
import 'package:mobile_app/features/reminders/reminders_screen.dart';
import 'package:mobile_app/features/schedules/schedule_appointment_view.dart';
import 'package:mobile_app/features/schedules/schedules_screen.dart';

class Routes {
  static const String home = HomeScreen.route;
  static const String patients = PatientsScreen.route;
  static const String patientDetails = PatientDetailsView.route;
  static const String addPatient = AddPatientScreen.route;
  static const String addPatientNote = AddPatientNoteView.route;
  static const String medications = MedicationsScreen.route;
  static const String addMedication = AddMedicationScreen.route;
  static const String schedules = SchedulesScreen.route;
  static const String scheduleAppointment = ScheduleAppointmentView.route;
  static const String reminders = RemindersScreen.route;
  static const String addReminder = AddReminderScreen.route;
}

Map<String, WidgetBuilder> getRoutes() {
  return {
    Routes.home: (context) => const MainScreen(),
    Routes.patients: (context) => const PatientsScreen(),
    Routes.medications: (context) => const MedicationsScreen(),
    Routes.addMedication: (context) => const AddMedicationScreen(),
    Routes.schedules: (context) => const SchedulesScreen(),
    Routes.reminders: (context) => const RemindersScreen(),
    Routes.addReminder: (context) => const AddReminderScreen(),
  };
}
