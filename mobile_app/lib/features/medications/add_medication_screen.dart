import 'package:flutter/material.dart';
import 'package:mobile_app/models/medication.dart';
import 'dart:math';

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
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _purposeController = TextEditingController();
  final _iconController = TextEditingController();
  final _rxNumberController = TextEditingController();
  final _refillsController = TextEditingController();
  final _pillsController = TextEditingController();

  List<bool> selectedDays = [true, true, true, true, true, true, true];
  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _purposeController.dispose();
    _iconController.dispose();
    _rxNumberController.dispose();
    _refillsController.dispose();
    _pillsController.dispose();
    super.dispose();
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
    
    // Initialize controller values for both modes
    _nameController.text = medication.name;
    _dosageController.text = medication.dosage;
    _frequencyController.text = medication.frequency;
    _purposeController.text = medication.purpose;
    _iconController.text = medication.icon;
    _rxNumberController.text = medication.rxNumber ?? '';
    _refillsController.text = medication.refillsRemaining?.toString() ?? '';
    _pillsController.text = medication.pillsRemaining.toString();
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
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medication name';
                    }
                    return null;
                  },
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
                  controller: _dosageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a dosage';
                    }
                    return null;
                  },
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
                  controller: _frequencyController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the frequency';
                    }
                    return null;
                  },
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
                  controller: _purposeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the purpose';
                    }
                    return null;
                  },
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
                  controller: _iconController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Enter an Icon (e.g. 💊, 💉)',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _rxNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Rx Number (Optional)',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _pillsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Pills Remaining',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _refillsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: 'Refills left',
                        ),
                      ),
                    ),
                  ],
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
                                color:
                                    selectedDays[i]
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
                              ),
                            ],
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

            final newMedication = Medication(
              id: Random().nextInt(100000), // Simple random ID
              name: _nameController.text,
              dosage: _dosageController.text,
              frequency: _frequencyController.text,
              frequencyWeekly: selectedDays,
              purpose: _purposeController.text,
              icon:
                  _iconController.text.isNotEmpty ? _iconController.text : '💊',
              color: Colors.primaries[Random().nextInt(
                Colors.primaries.length,
              )], // Random color
              nextDue: 'Scheduled', // Default value
              isActive: true,
              rxNumber: _rxNumberController.text.isNotEmpty ? _rxNumberController.text : null,
              pillsRemaining: int.tryParse(_pillsController.text) ?? 0,
              refillsRemaining: int.tryParse(_refillsController.text),
            );

            Navigator.pop(context, newMedication);
            return;
          }
        },
        heroTag: 'save_medication_fab',
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.check),
      ),
    );
  }
}
