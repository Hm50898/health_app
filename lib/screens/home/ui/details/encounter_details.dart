import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';

class EncounterDetailsScreen extends StatelessWidget {
  final Encounter encounter;

  const EncounterDetailsScreen({
    Key? key,
    required this.encounter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الزيارة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'الحالة',
              value: encounter.conditionName,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تاريخ الزيارة',
              value: encounter.encounterDate.toString().split(' ')[0],
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
