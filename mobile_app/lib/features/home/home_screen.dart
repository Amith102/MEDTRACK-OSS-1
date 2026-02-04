import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MedTrack')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to MedTrack',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'MedTrack is an open-source medication tracking system designed to help patients and caregivers manage medicines, schedules, and adherence in a simple and reliable way.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'What you can do here:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('• View and manage patient profiles'),
            Text('• Track prescribed medications'),
            Text('• Monitor medication schedules'),
            Text('• Review adherence history'),
            SizedBox(height: 20),
            Text(
              'This Flutter app is the mobile interface for MedTrack and connects to the existing backend APIs.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/patients');
                  },
                  icon: const Icon(Icons.people),
                  tooltip: 'View Patients',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/medications');
                  },
                  icon: const Icon(Icons.medication_liquid),
                  tooltip: 'View Medications',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/schedules');
                  },
                  icon: const Icon(Icons.schedule),
                  tooltip: 'View Schedules',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reminders');
                  },
                  icon: const Icon(Icons.alarm),
                  tooltip: 'View Reminders',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
