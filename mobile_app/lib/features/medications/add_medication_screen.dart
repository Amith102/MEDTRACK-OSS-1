import 'package:flutter/material.dart';
import 'package:mobile_app/models/medication.dart';

class AddMedicationScreen extends StatefulWidget {
  final Medication? existingMedication;
  const AddMedicationScreen({
    super.key,
    this.existingMedication,
  });
  static const String route = '/add_medication';

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  bool get isEditMode => widget.existingMedication != null;
  final _formKey = GlobalKey<FormState>();
  List<bool> selectedDays = [true, true, true, true, true, true, true];
  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  late Medication medication;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      medication = Medication(
        id: widget.existingMedication!.id,
        name: widget.existingMedication!.name,
        dosage: widget.existingMedication!.dosage,
        frequency: widget.existingMedication!.frequency,
        frequencyWeekly: List.from(widget.existingMedication!.frequencyWeekly),
        purpose: widget.existingMedication!.purpose,
        icon: widget.existingMedication!.icon,
        color: widget.existingMedication!.color,
        nextDue: widget.existingMedication!.nextDue,
        isActive: widget.existingMedication!.isActive,
      );
      selectedDays = medication.frequencyWeekly;
    } else {
      medication = Medication(
        id: _generateMedicationId(),
        name: '',
        dosage: '',
        frequency: '',
        frequencyWeekly: List<bool>.filled(7, true),
        purpose: '',
        icon: '',
        color: Colors.blueAccent,
        nextDue: '',
        isActive: true,
      );
    }
  }

  int _generateMedicationId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Medication' : 'Add Medication'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.existingMedication?.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a medication name';
                          }
                          return null;
                        },
                        onSaved: (newValue) => medication.name = newValue!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Enter medication name',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.existingMedication?.dosage,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a dosage';
                          }
                          return null;
                        },
                        onSaved: (newValue) => medication.dosage = newValue!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Enter dosage',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.existingMedication?.frequency,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the frequency';
                          }
                          return null;
                        },
                        onSaved: (newValue) => medication.frequency = newValue!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Enter frequency',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.existingMedication?.purpose,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the purpose';
                          }
                          return null;
                        },
                        onSaved: (newValue) => medication.purpose = newValue!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Enter purpose',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: widget.existingMedication?.icon,
                        onSaved: (newValue) => medication.icon = newValue ?? '',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Enter an Icon',
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < 7; i++)
                                GestureDetector(
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: selectedDays[i]
                                              ? Colors.greenAccent
                                              : Colors.grey.shade200,
                                          size: 30,
                                          semanticLabel: days[i],
                                        ),
                                        Text(
                                          days[i][0],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        )
                                      ]),
                                  onTap: () {
                                    setState(() {
                                      selectedDays[i] = !selectedDays[i];
                                    });
                                  },
                                ),
                            ]),
                      ),
                    ],
                  )))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!selectedDays.contains(true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select at least one day')),
              );
              return;
            }
            _formKey.currentState!.save();
            medication.frequencyWeekly = selectedDays;
            if (medication.icon == '' || medication.icon.isEmpty) {
              medication.icon = '💊';
            }
            Navigator.pop(context, medication);
          }
        },
        heroTag: 'save_medication_fab',
        backgroundColor: Colors.greenAccent,
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
