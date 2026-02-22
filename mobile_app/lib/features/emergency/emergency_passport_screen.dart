import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/profile_provider.dart';

class EmergencyPassportScreen extends StatelessWidget {
  const EmergencyPassportScreen({super.key});
  static const String route = '/emergency_passport';

  @override
  Widget build(BuildContext context) {
    final activeProfile = context.watch<ProfileProvider>().activeProfile;
    final emergencyModel = activeProfile?.emergencyProfile;

    // In a real app, this would fetch medications from a provider/API based on activeProfile.id
    // For MVP, we pass a static list to demonstrate generating the QR code JSON
    final sampleMedications = [
      {'name': 'Lisinopril', 'dosage': '10 mg'},
      {'name': 'Metformin', 'dosage': '500 mg'}
    ];

    final qrDataPayload = jsonEncode({
      'id': activeProfile?.id ?? 'Unknown',
      'name': activeProfile?.name ?? 'Unknown',
      'bloodType': emergencyModel?.bloodType ?? 'Unknown',
      'allergies': emergencyModel?.allergies ?? [],
      'medications': sampleMedications,
      'contactName': emergencyModel?.emergencyContactName ?? 'None',
      'contactPhone': emergencyModel?.emergencyContactPhone ?? 'None',
    });

    return Scaffold(
      backgroundColor: Colors.red[700],
      appBar: AppBar(
        title: const Text('EMERGENCY PASSPORT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        activeProfile?.name.toUpperCase() ?? 'NO PROFILE SELECTED',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (emergencyModel != null) ...[
                        _buildDataRow('Blood Type', emergencyModel.bloodType, isCritical: true),
                        const SizedBox(height: 8),
                        _buildDataRow('Allergies', emergencyModel.allergies.join(', '), isCritical: true),
                        const Divider(height: 32),
                        const Text('MEDICAL DATA SCAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: QrImageView(
                            data: qrDataPayload,
                            version: QrVersions.auto,
                            size: 200.0,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Scan for active medications list',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ] else ...[
                        const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
                        const SizedBox(height: 16),
                        const Text(
                          'No emergency profile configured for this user.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
                
                if (emergencyModel != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.contact_phone, color: Colors.red),
                            SizedBox(width: 8),
                            Text('EMERGENCY CONTACT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(emergencyModel.emergencyContactName, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(emergencyModel.emergencyContactPhone, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isCritical = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isCritical ? Colors.red[700] : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
