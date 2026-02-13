import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/patients/patients_screen.dart';
import 'package:mobile_app/features/patients/add_patient_screen.dart';
import 'package:mobile_app/features/patients/widgets/patient_details_view.dart';
import 'package:mobile_app/models/patient.dart';
import 'package:mobile_app/routes.dart';

void main() {
  Future<void> _setLargeTestSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1200, 2400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> _addPatient(
    WidgetTester tester, {
    required String name,
    required String age,
    required String condition,
  }) async {
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), name);
    await tester.enterText(textFields.at(1), age);
    await tester.tap(find.text('Male'));
    await tester.pumpAndSettle();
    await tester.enterText(textFields.at(2), condition);
    final addButton = find.widgetWithText(ElevatedButton, 'Add Patient️');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    expect(find.text('Patients'), findsOneWidget);
  }

  testWidgets(
    'added patient is shown in list and opens patient profile',
    (WidgetTester tester) async {
      await _setLargeTestSurface(tester);
      await tester.pumpWidget(
        MaterialApp(
          routes: getRoutes(),
          onGenerateRoute: (settings) {
            if (settings.name == Routes.addPatient) {
              return MaterialPageRoute<Patient>(
                builder: (context) => const AddPatientScreen(),
              );
            }
            if (settings.name == Routes.patientDetails) {
              if (settings.arguments is !Patient) {
                return null;
              }
              final patient = settings.arguments as Patient;
              return MaterialPageRoute(
                builder: (context) => PatientDetailsView(patient: patient),
              );
            }
            return null;
          },
          initialRoute: Routes.patients,
        )
      );

      await _addPatient(
        tester,
        name: 'John Doe',
        age: '34',
        condition: 'Fever',
      );

      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pumpAndSettle();
      final johnDoeInList = find.descendant(
        of: find.byType(ListView),
        matching: find.text('John Doe'),
      );
      expect(johnDoeInList, findsOneWidget);

      await tester.tap(johnDoeInList);
      await tester.pumpAndSettle();

      expect(find.text('Patient Profile'), findsOneWidget);
      expect(find.text('John Doe'), findsWidgets);
    },
  );

  testWidgets(
    'adding patient clears active search so new row is visible',
    (WidgetTester tester) async {
      await _setLargeTestSurface(tester);
      await tester.pumpWidget(const MaterialApp(home: PatientsScreen()));

      await tester.enterText(
        find.byType(TextField),
        'NoSuchPatientShouldMatchThis',
      );
      await tester.pumpAndSettle();
      expect(find.text('Rajesh Kumar'), findsNothing);

      await _addPatient(
        tester,
        name: 'Alice Brown',
        age: '29',
        condition: 'Migraine',
      );

      await tester.enterText(find.byType(TextField), 'Alice Brown');
      await tester.pumpAndSettle();
      final aliceInList = find.descendant(
        of: find.byType(ListView),
        matching: find.text('Alice Brown'),
      );
      expect(aliceInList, findsOneWidget);
      expect(find.text('NoSuchPatientShouldMatchThis'), findsNothing);
    },
  );
}
