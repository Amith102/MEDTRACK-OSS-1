import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import '../../models/patient.dart';
import 'widgets/patient_card.dart';
import '../../models/appointment.dart';
import '../../models/patient_note.dart';
import 'package:uuid/uuid.dart';

class ProfessionalPatientsScreen extends StatefulWidget {
  const ProfessionalPatientsScreen({super.key});
  static const String route = '/professional-patients';

  @override
  State<ProfessionalPatientsScreen> createState() => _ProfessionalPatientsScreenState();
}

class _ProfessionalPatientsScreenState extends State<ProfessionalPatientsScreen> {
  final List<Patient> _patients = [
    Patient(
      id: 'P001',
      name: 'Rajesh Kumar',
      age: 45,
      gender: 'Male',
      condition: 'Hypertension',
      status: 'Stable',
      lastVisit: DateTime.now().subtract(const Duration(days: 2)),
      phoneNumber: '+91 98765 43210',
      appointments: [
        Appointment(
          id: const Uuid().v4(),
          patientId: 'P001',
          date: DateTime.now().add(const Duration(days: 2)),
          time: const TimeOfDay(hour: 10, minute: 30),
          type: 'Follow-up',
          notes: 'Regular checkup for hypertension',
        ),
      ],
      notes: [
        PatientNote(
          id: const Uuid().v4(),
          patientId: 'P001',
          title: 'Initial Consultation',
          content: 'Patient reported persistent headaches. Recommended further tests.',
          category: 'Medical Condition',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),
    Patient(
      id: 'P002',
      name: 'Priya Sharma',
      age: 62,
      gender: 'Female',
      condition: 'Type 2 Diabetes',
      status: 'Recovering',
      lastVisit: DateTime.now().subtract(const Duration(days: 5)),
      phoneNumber: '+91 87654 32109',
    ),
    Patient(
      id: 'P003',
      name: 'Amit Patel',
      age: 28,
      gender: 'Male',
      condition: 'Asthma',
      status: 'Stable',
      lastVisit: DateTime.now().subtract(const Duration(days: 12)),
      phoneNumber: '+91 76543 21098',
    ),
    Patient(
      id: 'P004',
      name: 'Suresh Iyer',
      age: 75,
      gender: 'Male',
      condition: 'Post-Surgery (Knee)',
      status: 'Critical',
      lastVisit: DateTime.now().subtract(const Duration(hours: 4)),
      phoneNumber: '+91 65432 10987',
    ),
    Patient(
      id: 'P005',
      name: 'Lakshmi Narayan',
      age: 54,
      gender: 'Female',
      condition: 'Migraine',
      status: 'Stable',
      lastVisit: DateTime.now().subtract(const Duration(days: 20)),
      phoneNumber: '+91 99887 76655',
    ),
  ];

  String _searchQuery = '';
  String _quickFilter = 'All';
  String? _selectedGender;
  String? _selectedCondition;
  String _sortBy = 'Name';

  List<String> get _availableGenders => _patients.map((p) => p.gender).toSet().toList()..sort();
  List<String> get _availableConditions => _patients.map((p) => p.condition).toSet().toList()..sort();

  List<Patient> get _filteredPatients {
    var filtered = _patients.where((p) {
      final searchLower = _searchQuery.toLowerCase();
      final matchesQuery = p.name.toLowerCase().contains(searchLower) ||
          p.condition.toLowerCase().contains(searchLower) ||
          p.id.toLowerCase().contains(searchLower) ||
          p.phoneNumber.toLowerCase().contains(searchLower);
          
      bool matchesQuickFilter = true;
      final now = DateTime.now();
      if (_quickFilter == 'Requires Attention') {
        matchesQuickFilter = p.status == 'Critical';
      } else if (_quickFilter == 'Upcoming Appointments') {
        matchesQuickFilter = p.appointments.any((a) {
          final date = a.date;
          return date.isAfter(now) || (date.year == now.year && date.month == now.month && date.day == now.day);
        });
      } else if (_quickFilter == 'Recent Activity') {
        matchesQuickFilter = p.lastVisit.isAfter(now.subtract(const Duration(days: 7)));
      }

      final matchesGender = _selectedGender == null || p.gender == _selectedGender;
      final matchesCondition = _selectedCondition == null || p.condition == _selectedCondition;
      
      return matchesQuery && matchesQuickFilter && matchesGender && matchesCondition;
    }).toList();

    switch (_sortBy) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Age':
        filtered.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 'Last Visit':
        filtered.sort((a, b) => b.lastVisit.compareTo(a.lastVisit));
        break;
    }
    
    return filtered;
  }

  final List<String> _quickFilterOptions = ['All', 'Requires Attention', 'Upcoming Appointments', 'Recent Activity'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Patients'),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: (_selectedGender != null || _selectedCondition != null) 
                  ? Colors.blueAccent 
                  : Colors.grey[700],
            ),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          if (_selectedGender != null || _selectedCondition != null) _buildActiveFilters(),
          Expanded(
            child: _filteredPatients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredPatients[index];
                      return PatientCard(
                        patient: patient,
                        onTap: () => _navigateToPatientDetails(patient),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPatient = await Navigator.pushNamed(context, Routes.addPatient);
          if (newPatient != null && newPatient is Patient) {
            setState(() {
              _patients.add(newPatient);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search by name, ID, condition...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          if (_selectedGender != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InputChip(
                label: Text('Gender: $_selectedGender'),
                onDeleted: () => setState(() => _selectedGender = null),
                backgroundColor: Colors.blue.withOpacity(0.1),
                deleteIconColor: Colors.blue,
              ),
            ),
          if (_selectedCondition != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InputChip(
                label: Text('Condition: $_selectedCondition'),
                onDeleted: () => setState(() => _selectedCondition = null),
                backgroundColor: Colors.blue.withOpacity(0.1),
                deleteIconColor: Colors.blue,
              ),
            ),
          TextButton(
             onPressed: () => setState(() {
               _selectedGender = null;
               _selectedCondition = null;
             }),
             child: const Text('Clear All'),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _quickFilterOptions.map((filter) {
          final selected = _quickFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: selected,
              onSelected: (_) => setState(() => _quickFilter = filter),
              selectedColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No patients found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToPatientDetails(Patient patient) async {
    final result = await Navigator.pushNamed(
      context,
      Routes.patientDetails,
      arguments: patient,
    );

    if (result == 'delete') {
      setState(() {
        _patients.removeWhere((p) => p.id == patient.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${patient.name} deleted')),
      );
    } else if (result != null && result is Patient) {
      setState(() {
        final index = _patients.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          _patients[index] = result;
        }
      });
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter & Sort',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedGender = null;
                            _selectedCondition = null;
                            _sortBy = 'Name';
                          });
                          setState(() {}); // Update main screen
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  
                  // Sort By
                  Text(
                    'Sort By',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Name', 'Age', 'Last Visit'].map((sort) {
                      final selected = _sortBy == sort;
                      return ChoiceChip(
                        label: Text(sort),
                        selected: selected,
                        onSelected: (_) {
                          setModalState(() => _sortBy = sort);
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Gender Filter
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Genders')),
                      ..._availableGenders.map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g),
                          ))
                    ],
                    onChanged: (value) {
                      setModalState(() => _selectedGender = value);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),

                  // Condition Filter
                  DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    decoration: InputDecoration(
                      labelText: 'Condition',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                     items: [
                      const DropdownMenuItem(value: null, child: Text('All Conditions')),
                      ..._availableConditions.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c, overflow: TextOverflow.ellipsis),
                          ))
                    ],
                    onChanged: (value) {
                      setModalState(() => _selectedCondition = value);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
