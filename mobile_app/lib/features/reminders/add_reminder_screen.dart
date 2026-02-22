import 'package:flutter/material.dart';

import '../../models/reminder.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminderToEdit;
  const AddReminderScreen({super.key, this.reminderToEdit});
  final Reminder? existingReminder;

  const AddReminderScreen({super.key, this.existingReminder});
  static const String route = '/add_reminder';

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  bool get isEditing => widget.existingReminder != null;

  final _formKey = GlobalKey<FormState>();
  String _medicationName = '';
  String _patientName = '';
  TimeOfDay _scheduledTime = TimeOfDay.now();
  final List<String> _type = ['Morning', 'Afternoon', 'Evening', 'Weekly'];
  bool _isEnabled = true;
  int _notificationCount = 1;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    if (widget.reminderToEdit != null) {
      final reminder = widget.reminderToEdit!;
      _medicationName = reminder.medication;
      _patientName = reminder.patient;
      _selectedType = reminder.type;
      _isEnabled = reminder.isEnabled;
      _notificationCount = reminder.notificationCount;
      _scheduledTime = _parseTime(reminder.scheduledTime);
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      if (parts[1] == 'PM' && hour != 12) {
        hour += 12;
      } else if (parts[1] == 'AM' && hour == 12) {
        hour = 0;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    if (isEditing) {
      final reminder = widget.existingReminder!;
      _medicationName = reminder.medication;
      _patientName = reminder.patient;
      _scheduledTime = TimeOfDay.now();
      _selectedType = reminder.type;
      _notificationCount = reminder.notificationCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.reminderToEdit != null ? "Edit Reminder" : "Add Reminder",
            ),
          ),
              title: isEditing ? Text("Edit Reminder") : Text("Add Reminder")),
          body: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _patientName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Patient Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: "Patient Name",
                        ),
                        onSaved: (value) => _patientName = value ?? '',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: _medicationName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Medication Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(12)),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelText: "Medication Name"),
                        onSaved: (value) => _medicationName = value ?? '',
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Please select a type";
                          }
                          return null;
                        },
                        value: _selectedType,
                        hint: const Text("Type"),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _type.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value as String;
                          });
                        },
                        onSaved: (value) => _selectedType = value,
                      ),
                      SizedBox(height: 15),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text("Scheduled Time",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                )),
                            leading: Icon(
                              Icons.access_time_rounded,
                              color: Colors.blue,
                            ),
                            subtitle: Text(
                              _scheduledTime.format(context),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: TextButton(
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: _scheduledTime,
                                          initialEntryMode:
                                              TimePickerEntryMode.dial);
                                  if (timeOfDay != null) {
                                    setState(() {
                                      _scheduledTime = timeOfDay;
                                    });
                                  }
                                },
                                child: Text(
                                  "CHANGE",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ),
                      SizedBox(height: 15),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            "Notifications",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          leading: Icon(Icons.notification_add),
                          iconColor: Colors.blue,
                          subtitle: Text(
                              "$_notificationCount ${_notificationCount == 1 ? 'notification' : 'notifications'} before"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_notificationCount > 1) {
                                    setState(() {
                                      _notificationCount--;
                                    });
                                  }
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text(
                                "$_notificationCount",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_notificationCount < 5) {
                                    setState(() {
                                      _notificationCount++;
                                    });
                                  }
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedType != null) {
                            _formKey.currentState!.save();
                            final reminderId = widget.reminderToEdit?.id ??
                                DateTime.now().millisecondsSinceEpoch;
                            
                            final newReminder = Reminder(
                              id: reminderId,
                            final updatedReminder = Reminder(
                              id: isEditing
                                  ? widget.existingReminder!.id
                                  : DateTime.now().millisecondsSinceEpoch,
                              medication: _medicationName,
                              patient: _patientName,
                              scheduledTime: _scheduledTime.format(context),
                              type: _selectedType!,
                              isEnabled: _isEnabled,
                              notificationCount: _notificationCount,
                            );

                            Navigator.pop(context, updatedReminder);
                          }
                        },
                        child: Text(widget.reminderToEdit != null
                            ? "Update Reminder"
                            : "Add Reminder"),
                        child: isEditing
                            ? Text("Save Changes")
                            : Text("Add Reminder"),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
