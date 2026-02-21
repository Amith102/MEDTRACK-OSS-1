import 'package:flutter/material.dart';
import 'package:mobile_app/features/medications/add_medication_screen.dart';
import 'package:mobile_app/features/patients/add_patient_screen.dart';
import 'package:mobile_app/features/patients/widgets/add_patient_note_view.dart';
import 'package:mobile_app/features/patients/widgets/patient_details_view.dart';
import 'package:mobile_app/features/schedules/schedule_appointment_view.dart';
import 'package:mobile_app/models/medication.dart';
import 'package:mobile_app/models/patient.dart';
import 'package:mobile_app/models/patient_note.dart';
import 'package:mobile_app/routes.dart';
import 'theme/app_theme.dart';

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedTrack OSS',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.home,
      routes: getRoutes(),
      onGenerateRoute: (settings) {
        if (settings.name == Routes.scheduleAppointment) {
          if (settings.arguments is Patient) {
            final patient = settings.arguments as Patient;
            return MaterialPageRoute(
              builder: (context) => ScheduleAppointmentView(patient: patient),
            );
          } else if (settings.arguments is Map<String, dynamic>) {
            final args = settings.arguments as Map<String, dynamic>;
            final patient = args['patient'] as Patient;
            final appointment = args['appointment'] as Appointment?;
            return MaterialPageRoute(
              builder: (context) => ScheduleAppointmentView(patient: patient, existingAppointment: appointment),
            );
          }
          return MaterialPageRoute(builder: (context) => _errorScreen());
        }
        if (settings.name == Routes.addPatient) {
          if (settings.arguments is Patient) {
            final patient = settings.arguments as Patient;
            return MaterialPageRoute(
              builder: (context) => AddPatientScreen(existingPatient: patient),
            );
          }
          return MaterialPageRoute<Patient>(
            builder: (context) => const AddPatientScreen(),
          );
        }
        if (settings.name == Routes.addPatientNote) {
          if (settings.arguments is Patient) {
            final patient = settings.arguments as Patient;
            return MaterialPageRoute(
              builder: (context) => AddPatientNoteView(patient: patient),
            );
          } else if (settings.arguments is Map<String, dynamic>) {
            final args = settings.arguments as Map<String, dynamic>;
            final patient = args['patient'] as Patient;
            final note = args['note'] as PatientNote?;
            return MaterialPageRoute(
              builder: (context) =>
                  AddPatientNoteView(patient: patient, noteToEdit: note),
            );
          }
          return MaterialPageRoute(builder: (context) => _errorScreen());
        }
        if (settings.name == Routes.patientDetails) {
          if (settings.arguments is Patient) {
            final patient = settings.arguments as Patient;
            return MaterialPageRoute(
              builder: (context) => PatientDetailsView(patient: patient),
            );
          }
          return MaterialPageRoute(builder: (context) => _errorScreen());
        }
        if (settings.name == Routes.addMedication) {
          final medication = settings.arguments is Medication
              ? settings.arguments as Medication
              : null;

          return MaterialPageRoute(
            builder: (context) =>
                AddMedicationScreen(existingMedication: medication),
          );
        }

        // fallback for undefined routes
        return null;
      },
    );
  }

  Widget _errorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('An unexpected error occurred.')),
    );
  }
}
