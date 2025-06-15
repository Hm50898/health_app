import 'package:flutter/material.dart';
import '../../models/health_record_model.dart';
import '../details/medicine_details.dart';

class MedicineListScreen extends StatelessWidget {
  final List<List<Medicine>> medicinesSummary;

  const MedicineListScreen({
    Key? key,
    required this.medicinesSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allMedicines = medicinesSummary.expand((x) => x).toList();

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allMedicines.length,
        itemBuilder: (context, index) {
          final medicine = allMedicines[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                medicine.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF036666),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Dosage: ${medicine.dosePerTime}'),
                  Text('Frequency: Every ${medicine.frequencyInHours} hours'),
                  Text('Duration: ${medicine.durationInDays} days'),
                  Text('Start Date: ${medicine.date.toString().split(' ')[0]}'),
                  Text(
                      'Status: ${medicine.isOngoing ? 'Ongoing' : 'Completed'}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicineDetailsScreen(
                      medicine: medicine,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
