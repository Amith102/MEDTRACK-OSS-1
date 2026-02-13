import 'package:mobile_app/features/home/home_screen.dart';
import 'package:mobile_app/features/medications/add_medication_screen.dart';
import 'package:mobile_app/features/medications/medications_screen.dart';
import 'package:mobile_app/features/patients/add_patient_screen.dart';
import 'package:mobile_app/features/patients/patients_screen.dart';
import 'package:mobile_app/features/patients/widgets/patient_details_view.dart';
import 'package:mobile_app/features/reminders/reminders_screen.dart';
import 'package:mobile_app/features/schedules/schedules_screen.dart';

class Routes {
  static final String home = HomeScreen.route;
  static final String patients = PatientsScreen.route;
  static final String patientDetails = PatientDetailsView.route;
  static final String addPatient = AddPatientScreen.route;
  static final String medications = MedicationsScreen.route;
  static final String addMedication = AddMedicationScreen.route;
  static final String schedules = SchedulesScreen.route;
  static final String reminders = RemindersScreen.route;
}

getRoutes() {
  return {
    Routes.home: (context) => const HomeScreen(),
    Routes.patients: (context) => const PatientsScreen(),
    Routes.medications: (context) => const MedicationsScreen(),
    Routes.addMedication: (context) => const AddMedicationScreen(),
    Routes.schedules: (context) => const SchedulesScreen(),
    Routes.reminders: (context) => const RemindersScreen(),
  };
}
