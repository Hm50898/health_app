import 'package:flutter/material.dart';
import 'package:flutter_project/screens/home/models/health_record_model.dart';

class MedicinePage extends StatelessWidget {
  final List<Medicine> medicinesSummary;

  const MedicinePage({super.key, required this.medicinesSummary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF036666), width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF036666),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Medicines",
                style: TextStyle(
                  color: Color(0xFF036666),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: medicinesSummary.length,
          itemBuilder: (context, index) {
            final medicine = medicinesSummary[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF036666)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF036666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Dosage: ${medicine.dosePerTime}'),
                    Text('Frequency: Every ${medicine.frequencyInHours} hours'),
                    Text('Duration: ${medicine.durationInDays} days'),
                    Text(
                        'Start Date: ${medicine.date.toString().split(' ')[0]}'),
                    Text(
                        'Status: ${medicine.isOngoing ? "Ongoing" : "Completed"}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
