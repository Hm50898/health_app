import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';
import 'package:flutter_project/screens/home/models/health_record_model.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/prescription.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/medicine.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/disease.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/mlab.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/imagdetal.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getHealthRecordSummary(),
      child: Scaffold(
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
                  "Health Record",
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
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HealthRecordSummaryLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HealthRecordSummaryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeCubit>().getHealthRecordSummary();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is HealthRecordSummaryLoaded) {
                final healthRecord = HealthRecordModel.fromJson(state.data);
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildServiceCard(
                            'Medicine',
                            'images/Primary(2).png',
                            healthRecord.medicines.length,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicinePage(
                                      medicines: healthRecord.medicines),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'BMI',
                            'images/Primary (3).png',
                            healthRecord.bmiData != null ? 1 : 0,
                            () {
                              if (healthRecord.bmiData != null) {
                                _showBMIDetails(context, healthRecord.bmiData!);
                              }
                            },
                          ),
                          _buildServiceCard(
                            'Disease',
                            'images/Primary (4).png',
                            healthRecord.diseases.length,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiseasePage(
                                      diseases: healthRecord.diseases),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'Lab',
                            'images/lab.png',
                            healthRecord.labTests.length,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LabPage(labTests: healthRecord.labTests),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'Imaging',
                            'images/Imaging.png',
                            healthRecord.imaging.length,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagingPage(
                                      imaging: healthRecord.imaging),
                                ),
                              );
                            },
                          ),
                          _buildServiceCard(
                            'Prescription',
                            'images/Prescription.png',
                            healthRecord.prescriptions.length,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrescriptionPage(
                                      prescriptions:
                                          healthRecord.prescriptions),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      String title, String imagePath, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF036666)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 48, height: 48),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF036666),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count items',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBMIDetails(BuildContext context, BMIData bmiData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('BMI Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Height: ${bmiData.height} cm'),
            Text('Weight: ${bmiData.weight} kg'),
            Text('BMI: ${bmiData.bmi.toStringAsFixed(1)}'),
            Text('Category: ${bmiData.category}'),
            Text(
                'Last Updated: ${bmiData.measurementDate.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
