import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';

class DiseaseDetailsScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailsScreen({
    Key? key,
    required this.disease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المرض'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'اسم المرض',
              value: disease.conditionName,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تاريخ التشخيص',
              value: disease.date.toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'شدة المرض',
              value: disease.severity,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'ملاحظات',
              value: disease.note,
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
