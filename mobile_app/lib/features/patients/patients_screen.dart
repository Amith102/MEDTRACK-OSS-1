import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import '../../models/patient.dart';
import 'widgets/patient_card.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});
  static const String route = '/patients';

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
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
  String? _selectedGender;
  String? _selectedCondition;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _selectedStatus;
  List<Patient> get _filteredPatients {
    return _patients.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.condition.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _selectedStatus == null || p.status == _selectedStatus;

      final matchesGender =
          _selectedGender == null || p.gender == _selectedGender;

      final matchesCondition =
          _selectedCondition == null || p.condition == _selectedCondition;

      return matchesSearch &&
          matchesGender &&
          matchesCondition &&
          matchesStatus;
    }).toList();
  }

  List<String> get _availableGenders =>
      _patients.map((p) => p.gender).toSet().toList()..sort();

  List<String> get _availableStatus =>
      _patients.map((p) => p.status).toSet().toList()..sort();

  List<String> get _availableConditions =>
      _patients.map((p) => p.condition).toSet().toList()..sort();

  bool get _hasActiveFilters =>
      _selectedGender != null ||
      _selectedCondition != null ||
      _selectedStatus != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Patients',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _hasActiveFilters ? Theme.of(context).primaryColor : null,
            ),
            onPressed: _openFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              final newPatient = await Navigator.pushNamed<Patient>(
                context,
                Routes.addPatient,
              );
              if (newPatient != null) {
                _addPatientToList(newPatient);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_hasActiveFilters) _buildActiveFilters(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
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
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search patients, conditions...',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  void _addPatientToList(Patient patient) {
    final isVisibleWithCurrentView = _matchesCurrentView(patient);

    setState(() {
      _patients.add(patient);

      // Ensure newly added patient is immediately visible after submission.
      if (!isVisibleWithCurrentView) {
        _searchQuery = '';
        _selectedGender = null;
        _selectedCondition = null;
        _selectedStatus = null;
      }
    });

    if (!isVisibleWithCurrentView) {
      _searchController.clear();
    }
  }

  bool _matchesCurrentView(Patient patient) {
    final query = _searchQuery.toLowerCase();
    final matchesSearch = query.isEmpty ||
        patient.name.toLowerCase().contains(query) ||
        patient.condition.toLowerCase().contains(query);
    final matchesStatus =
        _selectedStatus == null || patient.status == _selectedStatus;

    final matchesGender =
        _selectedGender == null || patient.gender == _selectedGender;
    final matchesCondition =
        _selectedCondition == null || patient.condition == _selectedCondition;

    return matchesSearch && matchesGender && matchesCondition && matchesStatus;
  }

  Widget _buildActiveFilters() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedGender != null)
            Chip(
              label: Text('Gender: $_selectedGender'),
              onDeleted: () => setState(() => _selectedGender = null),
            ),
          if (_selectedStatus != null)
            Chip(
              label: Text('Status: $_selectedStatus'),
              onDeleted: () => setState(() => _selectedStatus = null),
            ),
          if (_selectedCondition != null)
            Chip(
              label: Text('Condition: $_selectedCondition'),
              onDeleted: () => setState(() => _selectedCondition = null),
            ),
          ActionChip(
            label: const Text('Clear all'),
            onPressed: () {
              setState(() {
                _selectedGender = null;
                _selectedCondition = null;
                _selectedStatus = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSheet() async {
    String? tempGender = _selectedGender;
    String? tempCondition = _selectedCondition;
    String? tempStatus = _selectedStatus;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Patients',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    initialValue: tempGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All genders'),
                      ),
                      ..._availableGenders.map(
                        (gender) => DropdownMenuItem<String?>(
                          value: gender,
                          child: Text(gender),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => tempGender = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: tempCondition,
                    decoration: const InputDecoration(
                      labelText: 'Condition',
                      border: OutlineInputBorder(),
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All conditions'),
                      ),
                      ..._availableConditions.map(
                        (condition) => DropdownMenuItem<String?>(
                          value: condition,
                          child: Text(condition),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => tempCondition = value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: tempStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Status'),
                      ),
                      ..._availableStatus.map(
                        (status) => DropdownMenuItem<String?>(
                          value: status,
                          child: Text(status),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => tempStatus = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempGender = null;
                              tempCondition = null;
                              tempStatus = null;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedGender = tempGender;
                              _selectedCondition = tempCondition;
                              _selectedStatus = tempStatus;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _navigateToPatientDetails(Patient patient) async {
    final updatedPatient = await Navigator.pushNamed(
      context,
      Routes.patientDetails,
      arguments: patient,
    );

    if (updatedPatient != null && updatedPatient is Patient) {
      setState(() {
        final index = _patients.indexWhere((p) => p.id == updatedPatient.id);
        if (index != -1) {
          _patients[index] = updatedPatient;
        }
      });
    } else if (updatedPatient == 'delete') {
      setState(() {
        _patients.removeWhere((p) => p.id == patient.id);
      });
    }
  }
}
