import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionDetailsScreen({
    Key? key,
    required this.prescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الوصفة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'اسم الطبيب',
              value: prescription.publisher,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تاريخ الوصفة',
              value: prescription.prescriptionDate.toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'الحالة',
              value: prescription.conditionName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
