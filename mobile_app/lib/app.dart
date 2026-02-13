import 'package:flutter/material.dart';
import 'package:mobile_app/features/patients/add_patient_screen.dart';
import 'package:mobile_app/features/patients/widgets/patient_details_view.dart';
import 'package:mobile_app/models/patient.dart';
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
        if (settings.name == Routes.addPatient) {
          return MaterialPageRoute<Patient>(
            builder: (context) => const AddPatientScreen(),
          );
        }
        if (settings.name == Routes.patientDetails) {
          final patient = settings.arguments as Patient;
          return MaterialPageRoute(
            builder: (context) => PatientDetailsView(patient: patient),
          );
        }
        
        // fallback for undefined routes
        return null;
      },
    );
  }
}
