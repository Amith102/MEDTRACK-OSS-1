import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import '../../models/patient.dart';
import 'widgets/patient_card.dart';

class ProfessionalPatientsScreen extends StatefulWidget {
  const ProfessionalPatientsScreen({super.key});

  @override
  State<ProfessionalPatientsScreen> createState() => _ProfessionalPatientsScreenState();
}

class _ProfessionalPatientsScreenState extends State<ProfessionalPatientsScreen> {
  final List<Patient> _patients = [
    // same patient list as before
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
