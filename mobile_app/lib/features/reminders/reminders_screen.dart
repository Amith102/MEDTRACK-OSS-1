import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';
import '../../models/reminder.dart';
import 'add_reminder_screen.dart';

// Mock reminder data
final ValueNotifier<List<Reminder>> reminders = ValueNotifier([
  Reminder(
    id: 1,
    medication: 'Lisinopril',
    patient: 'John Doe',
    scheduledTime: '08:00 AM',
    type: 'Morning',
    isEnabled: true,
    notificationCount: 3,
    icon: '📱',
  ),
  Reminder(
    id: 2,
    medication: 'Metformin',
    patient: 'John Doe',
    scheduledTime: '12:30 PM',
    type: 'Afternoon',
    isEnabled: true,
    notificationCount: 2,
    icon: '🔔',
  ),
  Reminder(
    id: 3,
    medication: 'Atorvastatin',
    patient: 'Jane Smith',
    scheduledTime: '09:00 PM',
    type: 'Evening',
    isEnabled: false,
    notificationCount: 0,
    icon: '🌙',
  ),
  Reminder(
    id: 4,
    medication: 'Aspirin',
    patient: 'Michael Johnson',
    scheduledTime: '08:00 AM',
    type: 'Morning',
    isEnabled: true,
    notificationCount: 1,
    icon: '⏰',
  ),
  Reminder(
    id: 5,
    medication: 'Blood Pressure Check',
    patient: 'John Doe',
    scheduledTime: '05:00 PM',
    type: 'Weekly',
    isEnabled: true,
    notificationCount: 2,
    icon: '💓',
  ),
]);

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});
  static const String route = '/reminders';

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  // Mock reminder data
  final List<Reminder> reminders = [
    Reminder(
      id: 1,
      medication: 'Lisinopril',
      patient: 'John Doe',
      scheduledTime: '08:00 AM',
      type: 'Morning',
      isEnabled: true,
      notificationCount: 3,
      icon: '📱',
    ),
    Reminder(
      id: 2,
      medication: 'Metformin',
      patient: 'John Doe',
      scheduledTime: '12:30 PM',
      type: 'Afternoon',
      isEnabled: true,
      notificationCount: 2,
      icon: '🔔',
    ),
    Reminder(
      id: 3,
      medication: 'Atorvastatin',
      patient: 'Jane Smith',
      scheduledTime: '09:00 PM',
      type: 'Evening',
      isEnabled: false,
      notificationCount: 0,
      icon: '🌙',
    ),
    Reminder(
      id: 4,
      medication: 'Aspirin',
      patient: 'Michael Johnson',
      scheduledTime: '08:00 AM',
      type: 'Morning',
      isEnabled: true,
      notificationCount: 1,
      icon: '⏰',
    ),
    Reminder(
      id: 5,
      medication: 'Blood Pressure Check',
      patient: 'John Doe',
      scheduledTime: '05:00 PM',
      type: 'Weekly',
      isEnabled: true,
      notificationCount: 2,
      icon: '💓',
    ),
  ];

  void _deleteReminder(int id) {
    setState(() {
      reminders.removeWhere((r) => r.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder deleted')),
    );
  }

  Future<void> _editReminder(Reminder reminder) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(reminderToEdit: reminder),
      ),
    );

    if (result != null && result is Reminder) {
      setState(() {
        final index = reminders.indexWhere((r) => r.id == reminder.id);
        if (index != -1) {
          reminders[index] = result;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Badge.count(
                count: reminders.value.where((r) => r.isEnabled).length,
                child: const Icon(Icons.notifications_rounded),
              ),
            ),
          ),
        ],
      ),
      body:
          reminders.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_rounded,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reminders set',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return _ReminderCard(
                    reminder: reminder,
                    onDelete: () => _deleteReminder(reminder.id),
                    onEdit: () => _editReminder(reminder),
                  );
                },
              ),
      body: ValueListenableBuilder(
        valueListenable: reminders,
        builder: (context, value, child) {
          return reminders.value.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reminders set',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount:
                      reminders.value.length, // Added .value to fix access
                  itemBuilder: (context, index) {
                    final reminder = reminders.value[index]; // Added .value
                    return _ReminderCard(
                      reminder: reminder,
                      onUpdate: (updatedItem) {
                        setState(() {
                          reminders.value[index] = updatedItem;
                        });
                      },
                    );
                  },
                );
        }, // This closing brace for the builder was missing
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, Routes.addReminder);
          if (result != null && result is Reminder) {
            setState(() {
              reminders.value = [...reminders.value, result];
            });
          }
        },
        heroTag: 'add_reminder_fab',
        backgroundColor: const Color(0xFF0066CC),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _ReminderCard extends StatefulWidget {
  final Reminder reminder;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ReminderCard({
    required this.reminder,
    required this.onDelete,
    required this.onEdit,
  });
  final Function(Reminder) onUpdate;

  const _ReminderCard({required this.reminder, required this.onUpdate});

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
  late bool _isEnabled;
  late Reminder _currentReminder;

  @override
  void initState() {
    super.initState();
    _currentReminder = widget.reminder;
    _isEnabled = widget.reminder.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(_currentReminder.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isEnabled ? typeColor.withOpacity(0.2) : Colors.grey[200]!,
          ),
          color: _isEnabled ? Colors.white : Colors.grey[50],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _currentReminder.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                // Reminder Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentReminder.medication,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: Text(
                              _currentReminder.type,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: typeColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_currentReminder.scheduledTime} • ${_currentReminder.patient}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Toggle
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                        _currentReminder = Reminder(
                            id: _currentReminder.id,
                            medication: _currentReminder.medication,
                            patient: _currentReminder.patient,
                            scheduledTime: _currentReminder.scheduledTime,
                            type: _currentReminder.type,
                            notificationCount:
                                _currentReminder.notificationCount);
                      });
                      widget.onUpdate(_currentReminder);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Reminder ${value ? 'enabled' : 'disabled'}',
                          ),
                        ),
                      );
                    },
                    activeThumbColor: typeColor,
                  ),
                ),
              ],
            ),
            if (_currentReminder.notificationCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.reminder.notificationCount} notification${widget.reminder.notificationCount > 1 ? 's' : ''} before the reminder',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                        '${_currentReminder.notificationCount} notification${_currentReminder.notificationCount > 1 ? 's' : ''} before the reminder',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onEdit,
                    onPressed: () async {
                      final updatedReminder = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddReminderScreen(
                            existingReminder: widget.reminder,
                          ),
                        ),
                      );
                      if (updatedReminder != null &&
                          updatedReminder is Reminder) {
                        setState(() {
                          _currentReminder = updatedReminder;
                        });
                        widget.onUpdate(updatedReminder);
                      }
                    },
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showLogIntakeDialog(context, widget.reminder);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Log'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Delete Reminder'),
                              content: const Text(
                                'Are you sure you want to delete this reminder?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onDelete();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    icon: const Icon(Icons.delete_rounded, size: 16),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogIntakeDialog(BuildContext context, Reminder reminder) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Medication Intake',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Did ${reminder.patient} take ${reminder.medication} today at ${reminder.scheduledTime}?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged as Taken')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Taken'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged as Skipped')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Skipped'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Morning':
        return const Color(0xFFFFC107);
      case 'Afternoon':
        return const Color(0xFF00B4D8);
      case 'Evening':
        return const Color(0xFF9C27B0);
      case 'Weekly':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF0066CC);
    }
  }
}
