import 'package:flutter/material.dart';
import '../../../models/patient.dart';
import '../../../models/patient_note.dart';
import 'package:uuid/uuid.dart';

class AddPatientNoteView extends StatefulWidget {
  final Patient patient;
  final PatientNote? noteToEdit;
  static const String route = '/add_patient_note';

  const AddPatientNoteView({
    super.key,
    required this.patient,
    this.noteToEdit,
  });

  @override
  State<AddPatientNoteView> createState() => _AddPatientNoteViewState();
}

class _AddPatientNoteViewState extends State<AddPatientNoteView> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _titleController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Medical Condition',
    'Prescription',
    'Observation',
    'Emergency',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.noteToEdit != null) {
      _titleController.text = widget.noteToEdit!.title;
      _noteController.text = widget.noteToEdit!.content;
      if (_categories.contains(widget.noteToEdit!.category)) {
        _selectedCategory = widget.noteToEdit!.category;
      } else {
        _selectedCategory = 'General';
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit != null ? 'Edit Note' : 'Add Note'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPatientInfoCard(context),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.label),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter note content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.noteToEdit != null ? 'Update Note' : 'Save Note',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            widget.patient.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.patient.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          'ID: ${widget.patient.id}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final newNote = PatientNote(
        id: widget.noteToEdit?.id ?? const Uuid().v4(),
        patientId: widget.patient.id,
        title: _titleController.text,
        content: _noteController.text,
        category: _selectedCategory,
        date: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.noteToEdit != null
                ? 'Note Updated Successfully'
                : 'Note Saved Successfully',
          ),
        ),
      );
      Navigator.pop(context, newNote);
    }
  }
}
