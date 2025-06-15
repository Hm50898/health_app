import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';

class ImagingDetailsScreen extends StatelessWidget {
  final Imaging imaging;

  const ImagingDetailsScreen({
    Key? key,
    required this.imaging,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الصورة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'نوع الصورة',
              value: imaging.medicalImageName,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'تاريخ الصورة',
              value: imaging.medicalImageDate.toString().split(' ')[0],
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
