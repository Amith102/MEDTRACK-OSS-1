import 'dart:math';

import 'package:flutter/material.dart';

final Random _random = Random();

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});
  static const int n = 10;
  static List<String> medications = List.generate(
    n,
    (index) => 'Medication ${index + 1}',
  );
  static List<String> dosages = List.generate(
    n,
    (index) => '${(index + 1) * 10} mg',
  );
  static List<String> times = List.generate(
    n,
    (index) => _random.nextInt(24).toString(),
  );
  static List<List<bool>> frequencies = List.generate(
    n,
    (index) => List.generate(7, (day) => _random.nextBool()),
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
        itemCount: MedicationsScreen.medications.length,
        itemBuilder: (context, index) {
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
                MedicationsScreen.medications[index],
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dosage: ${MedicationsScreen.dosages[index]}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Time: ${int.parse(MedicationsScreen.times[index]) % 12 == 0 ? 12 : (int.parse(MedicationsScreen.times[index]) % 12).toString()} ${int.parse(MedicationsScreen.times[index]) < 12 ? 'AM' : 'PM'}",
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
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][0]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][1]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][2]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][3]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][4]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][5]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
                      ),
                      Icon(
                        Icons.circle,
                        color: MedicationsScreen.frequencies[index][6]
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 15,
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
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
