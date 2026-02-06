import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<String> days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
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
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: timeOfDay,
                    );
                    if (picked != null) {
                      setState(() {
                        timeOfDay = picked;
                      });
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.access_time),
                      SizedBox(width: 8),
                      Text('${timeOfDay.hour}:${timeOfDay.minute}'),
                      SizedBox(width: 8),
                    ],
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
                            ]
                          ),
                          onTap: () {
                            setState(() {
                              selectedDays[i] = !selectedDays[i];
                            });
                          },
                        ),
                    ]
                  ),
                ),
              ],
            )
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!selectedDays.contains(true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select at least one day')),
              );
              return;
            }
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.greenAccent,
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
