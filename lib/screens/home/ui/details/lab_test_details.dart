import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';

class LabTestDetailsScreen extends StatelessWidget {
  final LabTest labTest;

  const LabTestDetailsScreen({
    Key? key,
    required this.labTest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التحليل'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'اسم التحليل',
              value: labTest.testName,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تاريخ التحليل',
              value: labTest.testDate.toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'النتيجة',
              value: labTest.result,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'ملاحظات',
              value: labTest.note,
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
