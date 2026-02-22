import 'package:flutter/material.dart';
import '../../../services/mock_weather_service.dart';

class AddSymptomView extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final String patientId;

  const AddSymptomView({
    Key? key,
    required this.onSave,
    required this.patientId,
  }) : super(key: key);

  @override
  State<AddSymptomView> createState() => _AddSymptomViewState();
}

class _AddSymptomViewState extends State<AddSymptomView> {
  final _formKey = GlobalKey<FormState>();
  final _symptomNameController = TextEditingController();
  final _notesController = TextEditingController();
  double _severity = 1.0;
  bool _isFetchingWeather = false;

  @override
  void dispose() {
    _symptomNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isFetchingWeather = true);
      
      final weatherService = MockWeatherService();
      final envContext = await weatherService.fetchCurrentConditions();

      final symptomData = {
        'patientId': widget.patientId,
        'date': DateTime.now().toIso8601String(),
        'symptomName': _symptomNameController.text.trim(),
        'severity': _severity.toInt(),
        'notes': _notesController.text.trim(),
        'environment': envContext.toJson(),
      };

      if (!mounted) return;
      setState(() => _isFetchingWeather = false);

      widget.onSave(symptomData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 24.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Log New Symptom',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _symptomNameController,
                decoration: const InputDecoration(
                  labelText: 'Symptom (e.g., Nausea, Headache)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sick),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a symptom name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Severity: ${_severity.toInt()}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _severity,
                min: 1,
                max: 10,
                divisions: 9,
                label: _severity.round().toString(),
                activeColor: _getSeverityColor(_severity.toInt()),
                onChanged: (double value) {
                  setState(() {
                    _severity = value;
                  });
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mild (1)'),
                  Text('Severe (10)'),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Optional Notes (Triggers, timing, etc.)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isFetchingWeather ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isFetchingWeather 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2)
                      )
                    : const Text('Save Symptom Log'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    if (severity <= 3) return Colors.green;
    if (severity <= 7) return Colors.orange;
    return Colors.red;
  }
}
