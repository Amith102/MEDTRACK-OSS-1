import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/medication.dart';

final Random _random = Random();

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});
  static const int n = 10;
  static final List<Medication> medicationList = List.generate(
    10,
    (index) => Medication(
      id: index.toString(),
      name: 'Medication ${index + 1}',
      dosage: '${(index + 1) * 10} mg',
      time: _random.nextInt(24).toString(),
      frequency: List.generate(7, (day) => _random.nextBool()),
    ),
  );

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: ListView.builder(
        itemCount: MedicationsScreen.medicationList.length,
        itemBuilder: (context, index) {
          int medTime = int.parse(MedicationsScreen.medicationList[index].time);
          return Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
              bottom: 0.0,
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              tileColor: Colors.blueAccent,
              title: Text(
                MedicationsScreen.medicationList[index].name,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dosage: ${MedicationsScreen.medicationList[index].dosage}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Time: ${medTime % 12 == 0 ? 12 : (medTime % 12).toString()} ${medTime < 12 ? 'AM' : 'PM'}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        "Frequency: ",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(
                        7,
                        (dayIndex) => Icon(
                          Icons.circle,
                          color: MedicationsScreen.medicationList[index].frequency[dayIndex]
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // Action to view medication details
              },
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add new medication
          Navigator.pushNamedAndRemoveUntil(context, '/add_medication', ModalRoute.withName('/medications'));
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
