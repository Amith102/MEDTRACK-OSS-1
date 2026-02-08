import 'package:flutter/material.dart';

import '../../models/medication.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  // Mock medication data
  final List<Medication> medications = [
    Medication(
      id: 1,
      name: 'Lisinopril',
      dosage: '10 mg',
      frequency: 'Once daily',
      frequencyWeekly: [true, true, true, true, true, true, true],
      purpose: 'Blood pressure control',
      icon: '💊',
      color: const Color(0xFFFF6B6B),
      nextDue: '2:00 PM',
      isActive: true,
    ),
    Medication(
      id: 2,
      name: 'Metformin',
      dosage: '500 mg',
      frequency: 'Twice daily',
      frequencyWeekly: [true, false, true, false, true, false, true],
      purpose: 'Diabetes management',
      icon: '💉',
      color: const Color(0xFF00B4D8),
      nextDue: '1:30 PM',
      isActive: true,
    ),
    Medication(
      id: 3,
      name: 'Atorvastatin',
      dosage: '20 mg',
      frequency: 'Once daily',
      frequencyWeekly: [true, true, true, true, true, true, true],
      purpose: 'Cholesterol control',
      icon: '⚕️',
      color: const Color(0xFF4CAF50),
      nextDue: '8:00 PM',
      isActive: true,
    ),
    Medication(
      id: 4,
      name: 'Aspirin',
      dosage: '81 mg',
      frequency: 'Once daily',
      frequencyWeekly: [true, true, true, true, true, true, true],
      purpose: 'Blood thinner',
      icon: '💊',
      color: const Color(0xFFFFC107),
      nextDue: 'Tomorrow 8:00 AM',
      isActive: false,
    ),
  ];

  String _filterValue = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredMeds = _filterValue == 'All'
        ? medications
        : _filterValue == 'Active'
            ? medications.where((m) => m.isActive).toList()
            : medications.where((m) => !m.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isActive: _filterValue == 'All',
                    onTap: () {
                      setState(() => _filterValue = 'All');
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Active',
                    isActive: _filterValue == 'Active',
                    onTap: () {
                      setState(() => _filterValue = 'Active');
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Inactive',
                    isActive: _filterValue == 'Inactive',
                    onTap: () {
                      setState(() => _filterValue = 'Inactive');
                    },
                  ),
                ],
              ),
            ),
          ),
          // Medications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredMeds.length,
              itemBuilder: (context, index) {
                final medication = filteredMeds[index];
                return _MedicationCard(medication: medication);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/add_medication', ModalRoute.withName('/medications'));
        },
        backgroundColor: const Color(0xFF0066CC),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0066CC) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF0066CC) : Colors.grey[300]!,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication medication;

  const _MedicationCard({required this.medication});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: medication.isActive ? medication.color.withOpacity(0.2) : Colors.grey[200]!,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  decoration: BoxDecoration(
                    color: medication.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    medication.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),
                // Medication Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              medication.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: medication.isActive
                                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Text(
                              medication.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: medication.isActive ? const Color(0xFF4CAF50) : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medication.dosage,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        medication.frequency,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      medication.purpose,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: medication.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Next: ${medication.nextDue}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: medication.color,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit medication feature coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
