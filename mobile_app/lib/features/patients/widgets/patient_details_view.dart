import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/patient.dart';
import '../../../models/appointment.dart';
import '../../../models/patient_note.dart';
import '../../../models/medication_log.dart';
import '../../../models/goal.dart';
import '../../../models/symptom_log.dart';
import '../../../models/vital_sign.dart';
import 'add_symptom_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../../services/profile_provider.dart';

class PatientDetailsView extends StatefulWidget {
  final Patient patient;
  static const String route = '/patient_details_view';

  const PatientDetailsView({super.key, required this.patient});

  @override
  State<PatientDetailsView> createState() => _PatientDetailsViewState();
}

class _PatientDetailsViewState extends State<PatientDetailsView> {
  late Patient _currentPatient;
  String _selectedVitalMetric = 'Heart Rate'; // Default metrics filter

  @override
  void initState() {
    super.initState();
    _currentPatient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    // Use PopScope to ensure we pass back the updated patient data when using the system back button
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_currentPatient);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_currentPatient),
            // onPressed: () => Navigator.pop(context, _currentPatient),
            tooltip: 'Back',
          ),
          title: const Text('Patient Profile'),
          actions: [
            IconButton(
              onPressed: _editPatient,
              icon: const Icon(Icons.edit),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _confirmDelete(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Patient',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildStatsGrid(context),
              const SizedBox(height: 16),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              _buildRecoveryGoals(context),
              const SizedBox(height: 16),
              _buildMedicationAdherence(context),
              const SizedBox(height: 16),
              _buildSymptomLogs(context),
              const SizedBox(height: 16),
              _buildVitalsChart(context),
              const SizedBox(height: 16),
              _buildMedicalHistory(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editPatient() async {
    final updatedPatient = await Navigator.pushNamed(
      context,
      Routes.addPatient,
      arguments: _currentPatient,
    );

    if (updatedPatient != null && updatedPatient is Patient) {
      setState(() {
        _currentPatient = updatedPatient;
      });
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Hero(
            tag: 'avatar_${_currentPatient.id}',
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                _currentPatient.name.substring(0, 1).toUpperCase(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentPatient.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${_currentPatient.id}',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[800]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadges(context, _currentPatient.gender, Icons.person),
              const SizedBox(width: 12),
              _buildBadges(context, '${_currentPatient.age} Years', Icons.cake),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(BuildContext context, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              context,
              'Blood Pressure',
              '120/80',
              'mmHg',
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              context,
              'Heart Rate',
              '72',
              'bpm',
              Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(context, 'Weight', '70', 'kg', Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            unit,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(context, Icons.call, 'Call', Colors.green,
              onTap: () {
            try {
              makePhoneCall(_currentPatient.phoneNumber);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Could not launch phone dialer: $e'),
              ));
            }
          }),
          _buildActionButton(context, Icons.message, 'Message', Colors.blue,
              onTap: () {
            sendSms(_currentPatient.phoneNumber);
          }),
          _buildActionButton(
              context, Icons.calendar_today, 'Schedule', Colors.purple,
              onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              Routes.scheduleAppointment,
              arguments: _currentPatient,
            );
            if (result != null && result is Appointment) {
              setState(() {
                _currentPatient.appointments.add(result);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Appointment scheduled for ${result.date.day}/${result.date.month}')),
              );
            }
          }),
            _buildActionButton(context, Icons.sick, 'Symptom', Colors.redAccent,
                onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return AddSymptomView(
                    patientId: _currentPatient.id,
                    onSave: (symptomData) {
                      final newLog = SymptomLog.fromJson(symptomData);
                      setState(() {
                        _currentPatient.symptomLogs.add(newLog);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Symptom logged successfully')),
                      );
                    },
                  );
                },
              );
            }),
            _buildActionButton(context, Icons.note_add, 'Add Note', Colors.orange,
                onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.addPatientNote,
                arguments: _currentPatient,
              );

              if (result != null && result is PatientNote) {
                setState(() {
                  _currentPatient.notes.add(result);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note added successfully')),
                );
              }
            }),
            _buildActionButton(context, Icons.summarize, 'Report', Colors.teal,
                onTap: () {
              Navigator.pushNamed(context, Routes.consultReport,
                  arguments: _currentPatient);
            }),
          ],
        ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
        ],
      ),
    );
  }

  Widget _buildMedicalHistory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_currentPatient.appointments.isNotEmpty)
            ..._currentPatient.appointments.map((appointment) {
              Color statusColor = Colors.purple;
              IconData statusIcon = Icons.calendar_today;
              
              if (appointment.status == 'Completed') {
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
              } else if (appointment.status == 'Cancelled') {
                statusColor = Colors.red;
                statusIcon = Icons.cancel;
              }

              return _buildHistoryItem(
                context,
                '${appointment.type} (${appointment.status})',
                '${appointment.date.day}/${appointment.date.month}/${appointment.date.year} • ${appointment.time.hour}:${appointment.time.minute.toString().padLeft(2, '0')}',
                statusIcon,
                color: statusColor,
                onTap: () => _showAppointmentActions(context, appointment),
              );
            }),
          if (_currentPatient.appointments.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text("No upcoming appointments",
                  style: TextStyle(
                      color: Colors.grey[600], fontStyle: FontStyle.italic)),
            ),
          const Divider(height: 32),
          Text(
            'History',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            context,
            'General Checkup',
            'Dr. Smith • Yesterday',
            Icons.medical_services,
          ),
          _buildHistoryItem(
            context,
            'Prescription Refill',
            'Pharmacy • 2 days ago',
            Icons.medication,
          ),
          _buildHistoryItem(
            context,
            'Lab Results',
            'Blood work • 1 week ago',
            Icons.science,
          ),
          const SizedBox(height: 24),
          _buildNotesList(context),
        ],
      ),
    );
  }

  Widget _buildMedicationAdherence(BuildContext context) {
    if (_currentPatient.medicationLogs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medication Adherence',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                   Icon(Icons.assessment_outlined, size: 48, color: Colors.grey[400]),
                   const SizedBox(height: 12),
                   Text(
                     'No intake data available',
                     style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                   ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final totalLogs = _currentPatient.medicationLogs.length;
    final takenLogs = _currentPatient.medicationLogs.where((l) => l.status == 'Taken').length;
    final adherenceRate = takenLogs / totalLogs;

    Color adherenceColor = Colors.green;
    if (adherenceRate < 0.5) {
      adherenceColor = Colors.red;
    } else if (adherenceRate < 0.8) {
      adherenceColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medication Adherence',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${(adherenceRate * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: adherenceColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: adherenceRate,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(adherenceColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$takenLogs of $totalLogs doses taken recently',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ..._currentPatient.medicationLogs.take(3).map((log) {
            final isTaken = log.status == 'Taken';
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isTaken ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  child: Icon(
                    isTaken ? Icons.check : Icons.close,
                    color: isTaken ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(log.medicationName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${log.scheduledTime.day}/${log.scheduledTime.month} • ${log.scheduledTime.hour}:${log.scheduledTime.minute.toString().padLeft(2, '0')}'),
                trailing: Text(
                  log.status,
                  style: TextStyle(
                    color: isTaken ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSymptomLogs(BuildContext context) {
    if (_currentPatient.symptomLogs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symptom Tracker',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                   Icon(Icons.monitor_heart_outlined, size: 48, color: Colors.grey[400]),
                   const SizedBox(height: 12),
                   Text(
                     'No symptoms logged',
                     style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                   ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Symptoms',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${_currentPatient.symptomLogs.length} logs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._currentPatient.symptomLogs.reversed.take(5).map((log) {
            Color severityColor = Colors.green;
            if (log.severity >= 8) {
              severityColor = Colors.red;
            } else if (log.severity >= 4) {
              severityColor = Colors.orange;
            }

            final parsedDate = DateTime.parse(log.date);

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: severityColor.withOpacity(0.1),
                  child: Text(
                    log.severity.toString(),
                    style: TextStyle(color: severityColor, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(log.symptomName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${parsedDate.day}/${parsedDate.month} • ${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')}'),
                    if (log.notes.isNotEmpty)
                       Padding(
                         padding: const EdgeInsets.only(top: 4),
                         child: Text(log.notes, style: const TextStyle(fontStyle: FontStyle.italic)),
                       ),
                    if (log.environment != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            _buildEnvChip(Icons.thermostat, log.environment!.temperature),
                            _buildEnvChip(Icons.water_drop, log.environment!.humidity),
                            _buildEnvChip(Icons.air, 'AQI: ${log.environment!.aqi}'),
                          ],
                        ),
                      ),
                  ],
                ),
                isThreeLine: log.notes.isNotEmpty || log.environment != null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEnvChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.blue[700]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.blue[700], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNotesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clinical Notes',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._currentPatient.notes.map(
          (note) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              note.category,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.blue,
                            ),
                            onPressed: () => _editNote(note),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteNote(note),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(note.content),
                  const SizedBox(height: 8),
                  Text(
                    '${note.date.day}/${note.date.month}/${note.date.year}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

    );
  }

  Widget _buildVitalsChart(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final activeDependent = profileProvider.activeProfile;
        
        List<VitalSign> vitals = [];
        if (activeDependent != null) {
          vitals = activeDependent.vitalsHistory;
        }

        final filteredVitals = vitals
            .where((v) => v.metricName == _selectedVitalMetric)
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vitals & Trends',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      if (activeDependent == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Please select an active dependent profile first.'))
                        );
                        return;
                      }

                      final result = await Navigator.pushNamed(
                        context, 
                        Routes.logVitals,
                        arguments: activeDependent.id,
                      );
                      
                      if (result != null && result is VitalSign) {
                         setState(() {
                             activeDependent.vitalsHistory.add(result);
                             _selectedVitalMetric = result.metricName; // Auto switch to newly logged metric
                         });
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Log Vital'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal[700],
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Metric Selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Heart Rate',
                    'Blood Pressure',
                    'Weight',
                    'Blood Sugar',
                  ].map((metric) {
                    final isSelected = metric == _selectedVitalMetric;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(metric),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedVitalMetric = metric;
                            });
                          }
                        },
                        selectedColor: Colors.teal[100],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.teal[900] : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Chart Area
              Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: filteredVitals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.show_chart, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 8),
                          Text(
                            'No $_selectedVitalMetric data logged yet.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : _buildLineChart(filteredVitals),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildLineChart(List<VitalSign> vitals) {
    if (vitals.isEmpty) return const SizedBox.shrink();

    // Map vitals to FlSpot coordinates
    final spots = <FlSpot>[];
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    
    // Safety check for empty or completely unparseable data
    bool hasValidData = false;

    for (int i = 0; i < vitals.length; i++) {
      final vital = vitals[i];
      final val = vital.numericValue;
      if (val != null) {
         hasValidData = true;
         spots.add(FlSpot(i.toDouble(), val));
         minY = min(minY, val);
         maxY = max(maxY, val);
      }
    }

    if (!hasValidData) {
       return Center(child: Text("Cannot graph this data format.", style: TextStyle(color: Colors.grey[600])));
    }

    // Add padding to Y axis
    final yRange = maxY - minY;
    minY = (minY - (yRange * 0.2)).floorToDouble();
    maxY = (maxY + (yRange * 0.2)).ceilToDouble();
    
    // Prevent zero range
    if (minY == maxY) {
       minY -= 10;
       maxY += 10;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: ((maxY - minY) / 5) > 0 ? ((maxY - minY) / 5) : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < vitals.length) {
                  final date = vitals[index].timestamp;
                  // Only show a few dates to prevent crowding
                  if (vitals.length < 5 || index % (vitals.length ~/ 4) == 0) {
                     return Padding(
                       padding: const EdgeInsets.only(top: 8.0),
                       child: Text(
                         '${date.month}/${date.day}',
                         style: TextStyle(color: Colors.grey[600], fontSize: 10),
                       ),
                     );
                  }
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (vitals.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.teal[600],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withOpacity(0.15),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
           touchTooltipData: LineTouchTooltipData(
             getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                   final vital = vitals[touchedSpot.x.toInt()];
                   return LineTooltipItem(
                      '${vital.value} ${vital.unit}\n${vital.timestamp.month}/${vital.timestamp.day}',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                   );
                }).toList();
             }
           )
        ),
      ),
    );
  }

  Widget _buildRecoveryGoals(BuildContext context) {
    if (_currentPatient.goals.isEmpty) {
       return const SizedBox.shrink(); // Hide if no goals
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recovery Goals & Badges',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._currentPatient.goals.map((goal) => _buildGoalCard(context, goal)),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal) {
    final bool isGoalCompleted = goal.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isGoalCompleted
            ? BorderSide(color: Colors.amber.shade300, width: 2)
            : BorderSide.none,
      ),
      elevation: isGoalCompleted ? 4 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isGoalCompleted
              ? LinearGradient(
                  colors: [Colors.amber.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isGoalCompleted ? Colors.amber.shade800 : Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (isGoalCompleted)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                       return Transform.scale(
                         scale: value,
                         child: Text(goal.badgeIcon, style: const TextStyle(fontSize: 40)),
                       );
                    }
                  )
                else
                  Text(
                     '${(goal.progress * 100).toInt()}%',
                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                    isGoalCompleted ? Colors.amber : Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 16),
            ...goal.milestones.map((milestone) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      milestone.isCompleted = !milestone.isCompleted;
                    });
                    
                    if (goal.isCompleted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           backgroundColor: Colors.amber.shade800,
                           content: Row(
                             children: [
                               Text(goal.badgeIcon, style: const TextStyle(fontSize: 24)),
                               const SizedBox(width: 12),
                               const Text('Goal Completed! Badge Unlocked!', style: TextStyle(fontWeight: FontWeight.bold)),
                             ],
                           )
                         )
                       );
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: milestone.isCompleted ? Colors.green.withOpacity(0.05) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                         color: milestone.isCompleted ? Colors.green.withOpacity(0.3) : Colors.grey.shade200
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          milestone.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: milestone.isCompleted ? Colors.green : Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            milestone.title,
                            style: TextStyle(
                              color: milestone.isCompleted ? Colors.black87 : Colors.black54,
                              decoration: milestone.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAppointmentActions(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Manage Appointment',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              if (appointment.status == 'Scheduled')
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text('Mark as Completed'),
                  onTap: () {
                    Navigator.pop(context);
                    _updateAppointmentStatus(appointment, 'Completed');
                  },
                ),
              if (appointment.status == 'Scheduled')
                ListTile(
                  leading: const Icon(Icons.edit_calendar, color: Colors.orange),
                  title: const Text('Reschedule'),
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await Navigator.pushNamed(
                      context,
                      Routes.scheduleAppointment,
                      arguments: {
                        'patient': _currentPatient,
                        'appointment': appointment,
                      },
                    );
                    
                    if (result != null && result is Appointment) {
                      _updateAppointmentData(result);
                    }
                  },
                ),
              if (appointment.status == 'Scheduled')
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.red),
                  title: const Text('Cancel Appointment'),
                  onTap: () {
                    Navigator.pop(context);
                    _updateAppointmentStatus(appointment, 'Cancelled');
                  },
                ),
                
              if (appointment.status != 'Scheduled')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'This appointment is already ${appointment.status.toLowerCase()}.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _updateAppointmentStatus(Appointment appointment, String newStatus) {
    final updatedAppointment = appointment.copyWith(status: newStatus);
    _updateAppointmentData(updatedAppointment);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment marked as $newStatus')),
    );
  }

  void _updateAppointmentData(Appointment updatedAppointment) {
    setState(() {
      final index = _currentPatient.appointments.indexWhere((a) => a.id == updatedAppointment.id);
      if (index != -1) {
        _currentPatient.appointments[index] = updatedAppointment;
      }
    });
  }

  Future<void> _editNote(PatientNote note) async {
    final result =
        await Navigator.pushNamed(context, Routes.addPatientNote, arguments: {
      'patient': _currentPatient,
      'note': note,
    });

    if (result != null && result is PatientNote) {
      setState(() {
        final index = _currentPatient.notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          _currentPatient.notes[index] = result;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully')),
      );
    }
  }

  Future<void> _deleteNote(PatientNote note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _currentPatient.notes.removeWhere((n) => n.id == note.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully')),
      );
    }
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    Color color = Colors.blue,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Patient'),
          content: Text(
              'Are you sure you want to delete ${_currentPatient.name}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      if (mounted) {
        Navigator.of(context).pop('delete');
      }
    }
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw StateError('Could not launch $phoneNumber');
  }
}

Future<void> sendSms(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}
