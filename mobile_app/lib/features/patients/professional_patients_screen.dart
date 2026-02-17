import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import '../../models/patient.dart';
import 'widgets/patient_card.dart';

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
  String _statusFilter = 'All';

  List<Patient> get _filteredPatients {
    return _patients.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.condition.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == 'All' || p.status == _statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  final List<String> _statusOptions = ['All', 'Stable', 'Recovering', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Patients'),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
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
        onPressed: () {
          Navigator.pushNamed(context, Routes.addPatient);
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
          hintText: 'Search patients, conditions...',
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

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _statusOptions.map((status) {
          final selected = _statusFilter == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: selected,
              onSelected: (_) => setState(() => _statusFilter = status),
              selectedColor: Colors.blueAccent,
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

  void _navigateToPatientDetails(Patient patient) {
    Navigator.pushNamed(
      context,
      Routes.patientDetails,
      arguments: patient,
    );
  }
}
