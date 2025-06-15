import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الدواء'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'اسم الدواء',
              value: medicine.name,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'الجرعة',
              value: medicine.dosePerTime,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'مدة العلاج',
              value: '${medicine.durationInDays} يوم',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تكرار الجرعة',
              value: 'كل ${medicine.frequencyInHours} ساعة',
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تاريخ البدء',
              value: medicine.date.toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'حالة الدواء',
              value: medicine.isOngoing ? 'مستمر' : 'منتهي',
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
