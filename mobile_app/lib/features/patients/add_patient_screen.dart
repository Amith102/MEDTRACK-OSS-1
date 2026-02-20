import 'package:flutter/material.dart';
import '../../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  final Patient? existingPatient; // Optional for editing
  const AddPatientScreen({super.key, this.existingPatient});
  static const String route = '/add_patient';

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  bool get isEditing => widget.existingPatient != null;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _age = 0;
  String _condition = '';
  String _gender = '';
  String _status = '';
  bool _isGenderFocused = false;
  String? _genderError;
  String? _statusError;
  final FocusNode _genderFocusNode = FocusNode();
  bool _isStatusFocused = false; // Tracking focus for status box
  final FocusNode _statusFocusNode = FocusNode(); // Unique node for status

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final patient = widget.existingPatient!;
      _name = patient.name;
      _age = patient.age;
      _gender = patient.gender;
      _condition = patient.condition;
      _status = patient.status;
    }
  }

  String _generatePatientId() {
    return widget.existingPatient?.id ??
        'P${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void dispose() {
    _genderFocusNode.dispose();
    _statusFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar:
            AppBar(title: Text(isEditing ? "Edit Patient" : "Add New Patient")),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Patient's Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Patient's Name",
                    ),
                    onSaved: (value) => _name = value ?? '',
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: _age == 0 ? '' : _age.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Patient's Age";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Patient's Age",
                    ),
                    onSaved: (value) => _age = int.tryParse(value ?? '') ?? 0,
                  ),
                  SizedBox(height: 15),
                  Focus(
                    focusNode: _genderFocusNode,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isGenderFocused = hasFocus;
                      });
                    },
                    child: InputDecorator(
                      isFocused: _isGenderFocused,
                      decoration: InputDecoration(
                        hoverColor: Colors.red,
                        errorText: _genderError,
                        labelText: "Select Gender",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: _gender.isNotEmpty ? _gender : null,
                            onChanged: (value) => setState(() {
                              _gender = value!;
                              _genderFocusNode.requestFocus();
                            }),
                          ),
                          RadioListTile<String>(
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: _gender.isNotEmpty ? _gender : null,
                            onChanged: (value) => setState(() {
                              _gender = value!;
                              _genderFocusNode.requestFocus();
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: _condition,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Patient's Condition";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Patient's Condition",
                    ),
                    onSaved: (value) => _condition = value ?? '',
                  ),
                  SizedBox(height: 15),
                  Focus(
                    focusNode: _statusFocusNode,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isStatusFocused = hasFocus;
                      });
                    },
                    child: InputDecorator(
                      isFocused: _isStatusFocused,
                      decoration: InputDecoration(
                        hoverColor: Colors.red,
                        errorText: _statusError,
                        labelText: "Select Current Status",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Stable'),
                            value: 'Stable',
                            groupValue: _status.isNotEmpty ? _status : null,
                            onChanged: (value) => setState(() {
                              _status = value!;
                              _statusFocusNode.requestFocus();
                            }),
                          ),
                          RadioListTile<String>(
                            title: const Text('Critical'),
                            value: 'Critical',
                            groupValue: _status.isNotEmpty ? _status : null,
                            onChanged: (value) => setState(() {
                              _status = value!;
                              _statusFocusNode.requestFocus();
                            }),
                          ),
                          RadioListTile<String>(
                            title: const Text('Recovering'),
                            value: 'Recovering',
                            groupValue: _status.isNotEmpty ? _status : null,
                            onChanged: (value) => setState(() {
                              _status = value!;
                              _statusFocusNode.requestFocus();
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _genderError = _gender.isEmpty
                            ? "Please Enter Patient's Gender"
                            : null;
                        _statusError = _status.isEmpty
                            ? "Please Enter Patient's Status"
                            : null;
                      });

                      if (_formKey.currentState!.validate() &&
                          _gender.isNotEmpty &&
                          _status.isNotEmpty) {
                        _formKey.currentState!.save();
                        if (isEditing) {
                          final updatedPatient = Patient(
                            id: widget.existingPatient!.id,
                            name: _name,
                            age: _age,
                            gender: _gender,
                            condition: _condition,
                            status: _status,
                            lastVisit: widget.existingPatient!.lastVisit,
                            phoneNumber: widget.existingPatient!.phoneNumber,
                          );
                          Navigator.pop(context, updatedPatient);
                          return;
                        }
                        final newPatient = Patient(
                          id: _generatePatientId(),
                          name: _name,
                          age: _age,
                          gender: _gender,
                          condition: _condition,
                          status: _status,
                          lastVisit: widget.existingPatient?.lastVisit ??
                              DateTime.now(),
                          phoneNumber:
                              widget.existingPatient?.phoneNumber ?? 'N/A',
                        );
                        Navigator.pop(context, newPatient);
                      }
                    },
                    child: Text(isEditing ? "Save Changes" : "Add Patient"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
