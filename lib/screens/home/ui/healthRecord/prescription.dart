import 'package:flutter/material.dart';
import 'package:flutter_project/screens/home/models/health_record_model.dart';
import 'package:flutter_project/screens/home/ui/details/prescription_details.dart';

class PrescriptionPage extends StatelessWidget {
  final List<Prescription> prescriptionsSummary;

  const PrescriptionPage({super.key, required this.prescriptionsSummary});

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
                "Prescriptions",
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
          itemCount: prescriptionsSummary.length,
          itemBuilder: (context, index) {
            final prescription = prescriptionsSummary[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PrescriptionDetailsScreen(prescription: prescription),
                  ),
                );
              },
              child: Card(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dr. ${prescription.publisher}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF036666),
                            ),
                          ),
                          Text(
                            prescription.prescriptionDate
                                .toString()
                                .split(' ')[0],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Condition: ${prescription.conditionName}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
