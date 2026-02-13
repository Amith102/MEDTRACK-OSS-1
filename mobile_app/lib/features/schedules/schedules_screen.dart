import 'package:flutter/material.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});
  static String route = '/schedules';

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  // Mock schedule data
  final List<_ScheduleEntry> schedules = [
    _ScheduleEntry(
      medication: 'Lisinopril',
      dosage: '10 mg',
      time: '08:00 AM',
      patient: 'John Doe',
      status: 'Completed',
      statusColor: const Color(0xFF4CAF50),
      icon: '💊',
    ),
    _ScheduleEntry(
      medication: 'Metformin',
      dosage: '500 mg',
      time: '12:30 PM',
      patient: 'John Doe',
      status: 'Pending',
      statusColor: const Color(0xFFFFC107),
      icon: '💉',
    ),
    _ScheduleEntry(
      medication: 'Lisinopril',
      dosage: '10 mg',
      time: '08:00 PM',
      patient: 'John Doe',
      status: 'Upcoming',
      statusColor: const Color(0xFF00B4D8),
      icon: '💊',
    ),
    _ScheduleEntry(
      medication: 'Atorvastatin',
      dosage: '20 mg',
      time: '09:00 PM',
      patient: 'Jane Smith',
      status: 'Completed',
      statusColor: const Color(0xFF4CAF50),
      icon: '⚕️',
    ),
    _ScheduleEntry(
      medication: 'Aspirin',
      dosage: '81 mg',
      time: 'Tomorrow 08:00 AM',
      patient: 'Michael Johnson',
      status: 'Upcoming',
      statusColor: const Color(0xFF00B4D8),
      icon: '💊',
    ),
  ];

  String _filterValue = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredSchedules = _filterValue == 'All'
        ? schedules
        : schedules.where((s) => s.status == _filterValue).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Schedules'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Status Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    label: 'All',
                    isActive: _filterValue == 'All',
                    color: const Color(0xFF0066CC),
                    onTap: () {
                      setState(() => _filterValue = 'All');
                    },
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Completed',
                    isActive: _filterValue == 'Completed',
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      setState(() => _filterValue = 'Completed');
                    },
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Pending',
                    isActive: _filterValue == 'Pending',
                    color: const Color(0xFFFFC107),
                    onTap: () {
                      setState(() => _filterValue = 'Pending');
                    },
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: 'Upcoming',
                    isActive: _filterValue == 'Upcoming',
                    color: const Color(0xFF00B4D8),
                    onTap: () {
                      setState(() => _filterValue = 'Upcoming');
                    },
                  ),
                ],
              ),
            ),
          ),
          // Schedules List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredSchedules.length,
              itemBuilder: (context, index) {
                final schedule = filteredSchedules[index];
                return _ScheduleCard(schedule: schedule);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleEntry {
  final String medication;
  final String dosage;
  final String time;
  final String patient;
  final String status;
  final Color statusColor;
  final String icon;

  _ScheduleEntry({
    required this.medication,
    required this.dosage,
    required this.time,
    required this.patient,
    required this.status,
    required this.statusColor,
    required this.icon,
  });
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.grey[300]!,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? color : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final _ScheduleEntry schedule;

  const _ScheduleCard({required this.schedule});

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
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  decoration: BoxDecoration(
                    color: schedule.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    schedule.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                // Schedule Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.medication,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.dosage,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  decoration: BoxDecoration(
                    color: schedule.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    schedule.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: schedule.statusColor,
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    schedule.time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    schedule.patient,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Action Button
            schedule.status == 'Pending'
                ? ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Medication marked as taken!')),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Mark as Taken'),
                  )
                : schedule.status == 'Upcoming'
                    ? OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reminder set!')),
                          );
                        },
                        icon: const Icon(Icons.notifications_rounded, size: 18),
                        label: const Text('Set Reminder'),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: schedule.statusColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: schedule.statusColor,
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
