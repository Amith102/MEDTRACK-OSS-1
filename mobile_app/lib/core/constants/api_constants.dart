import 'package:mobile_app/routes.dart';

class ApiConstants {
  // Base URL for the FastAPI backend
  // Assume running locally on default FastAPI port
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // Endpoints
  static final String patients = Routes.patients;
  static final String medications = Routes.medications;
  static final String schedules = Routes.schedules;
}
