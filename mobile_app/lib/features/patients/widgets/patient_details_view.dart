import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/patient.dart';
import '../../../models/appointment.dart';
import '../../../models/patient_note.dart';

class PatientDetailsView extends StatefulWidget {
  final Patient patient;
  static const String route = '/patient_details_view';

  const PatientDetailsView({super.key, required this.patient});

  @override
  State<PatientDetailsView> createState() => _PatientDetailsViewState();
}

class _PatientDetailsViewState extends State<PatientDetailsView> {
  late Patient _currentPatient;

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
              return _buildHistoryItem(
                context,
                appointment.type,
                '${appointment.date.day}/${appointment.date.month}/${appointment.date.year} • ${appointment.time.hour}:${appointment.time.minute.toString().padLeft(2, '0')}',
                Icons.calendar_today,
                color: Colors.purple,
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
        onTap: () {},
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
