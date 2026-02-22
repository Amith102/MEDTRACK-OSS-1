import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';

import 'package:mobile_app/routes.dart';
import '../../models/medication.dart';
import '../../models/medication_log.dart';
import '../../models/audit_log_entry.dart';
import 'package:provider/provider.dart';
import '../../services/profile_provider.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});
  static const String route = '/medications';

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  // Mock medication data
  List<Medication> medications = [
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
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                final activeProfileId = profileProvider.activeProfile?.id;
                
                // Mock filtering logic for medications
                final profileMeds = filteredMeds.where((m) {
                   bool matchesProfile = false;
                   if (activeProfileId == 'D001' && (m.id == 1 || m.id == 2)) matchesProfile = true;
                   if (activeProfileId == 'D002' && m.id == 3) matchesProfile = true;
                   if (activeProfileId == 'D003' && m.id == 4) matchesProfile = true;
                   
                   if ([1, 2, 3, 4].contains(m.id) == false) {
                      matchesProfile = true;
                   }
                   return matchesProfile;
                }).toList();
                
                if (profileMeds.isEmpty) {
                   return const Center(child: Text("No medications found for this dependent."));
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: profileMeds.length,
                  itemBuilder: (context, index) {
                    final medication = profileMeds[index];
                    return _MedicationCard(
                  medication: medication,
                  profileProvider: profileProvider,
                  onEdit: () => _editMedication(context, medication),
                  onTakeDose: () {
                    setState(() {
                      if (medication.pillsRemaining > 0) {
                        medication.pillsRemaining--;
                        
                        // Create Audit Log
                        final caregiverName = profileProvider.primaryCaregiver?.name ?? "Primary Caregiver";
                        final aLog = AuditLogEntry(
                           id: DateTime.now().millisecondsSinceEpoch.toString(),
                           timestamp: DateTime.now(),
                           action: "Administered ${medication.dosage} of ${medication.name}",
                           caregiverName: caregiverName,
                           type: "medication"
                        );

                        // Attach to active dependent profile 
                        if (profileProvider.activeProfile != null) {
                           profileProvider.activeProfile!.activityFeed.add(aLog);
                        }

                        // Show a quick snackbar confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Dose taken. ${medication.pillsRemaining} pills remaining."),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cannot take dose: Out of pills!"),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    });
                  },
                );
                  },
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            Routes.addMedication,
          );

          if (result != null && result is Medication) {
            setState(() {
              medications.add(result);
              // Reset filter to 'All' or 'Active' to ensure the new med is visible if it matches
              if (_filterValue == 'Inactive') {
                _filterValue = 'All';
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${result.name} added successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          await _newMedication(context);
        },
        heroTag: 'add_medication_fab',
        backgroundColor: const Color(0xFF0066CC),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> _newMedication(BuildContext context) async {
    final newMedication =
        await Navigator.pushNamed(context, Routes.addMedication);
    if (newMedication != null && newMedication is Medication) {
      setState(() {
        medications.add(newMedication);
      });
    }
  }

  Future<void> _editMedication(
      BuildContext context, Medication medicationToEdit) async {
    final updatedMedication = await Navigator.pushNamed(
        context, Routes.addMedication,
        arguments: medicationToEdit);

    if (updatedMedication != null && updatedMedication is Medication) {
      setState(() {
        int index = medications.indexWhere((m) => m.id == updatedMedication.id);
        if (index != -1) {
          medications[index] = updatedMedication;
        }
      });
    }
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
  final ProfileProvider profileProvider;
  final VoidCallback onEdit;
  final VoidCallback? onTakeDose; // Add onTakeDose callback

  const _MedicationCard({required this.medication, required this.profileProvider, required this.onEdit, this.onTakeDose});

  @override
  Widget build(BuildContext context) {
    bool isLowInventory = medication.pillsRemaining <= 5;
    bool needsDoctorAuth = isLowInventory && (medication.refillsRemaining == null || medication.refillsRemaining == 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLowInventory 
                ? Colors.redAccent.withOpacity(0.5) 
                : medication.isActive
                  ? medication.color.withOpacity(0.2)
                  : Colors.grey[200]!,
            width: isLowInventory ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              medication.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: medication.isActive
                                    ? const Color(0xFF4CAF50)
                                    : Colors.black54,
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
            
            // Refill Warning Section
            if (isLowInventory) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      needsDoctorAuth ? Icons.warning_amber_rounded : Icons.local_pharmacy_outlined,
                      size: 20,
                      color: Colors.red[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            needsDoctorAuth 
                              ? 'Contact Doctor: 0 Refills Left!' 
                              : 'Low Supply: ${medication.pillsRemaining} pills left',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          if (!needsDoctorAuth)
                            Text(
                              'Rx: ${medication.rxNumber ?? 'Unknown'} • Refills: ${medication.refillsRemaining}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red[700],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

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
                if (onTakeDose != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: onTakeDose,
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Take'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: onEdit,
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
