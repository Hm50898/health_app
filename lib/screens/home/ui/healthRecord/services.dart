import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';
import 'package:flutter_project/screens/home/models/health_record_model.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/disease_list.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/lab_list.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/imaging.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/prescription.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/encounter_list.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/medicine.dart';
import 'package:flutter_project/screens/home/ui/healthRecord/ibm.dart';

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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildServiceCard(
                        'Diseases',
                        Icons.medical_services,
                        healthRecord.conditionsSummary.length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiseaseListScreen(
                                conditionsSummary:
                                    healthRecord.conditionsSummary,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        'Lab Tests',
                        Icons.science,
                        healthRecord.labTestsSummary.length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LabListScreen(
                                labTestsSummary: healthRecord.labTestsSummary,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        'Medical Images',
                        Icons.image,
                        healthRecord.medicalImagesSummary.length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImagingPage(
                                imaging: healthRecord.medicalImagesSummary,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        'Prescriptions',
                        Icons.description,
                        healthRecord.prescriptionsSummary.length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrescriptionPage(
                                prescriptionsSummary:
                                    healthRecord.prescriptionsSummary,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        'Medicines',
                        Icons.medication,
                        healthRecord.medicinesSummary.length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicinePage(
                                medicinesSummary: healthRecord.medicinesSummary,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        'Encounters',
                        Icons.event_note,
                        healthRecord.encountersSummary.expand((x) => x).length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EncounterListScreen(
                                encountersSummary:
                                    healthRecord.encountersSummary,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        'IBM',
                        Icons.analytics,
                        healthRecord.encountersSummary.expand((x) => x).length,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IBMPage(
                                encountersSummary:
                                    healthRecord.encountersSummary,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: Text('No data available'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      String title, IconData icon, int count, VoidCallback onTap) {
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
            Icon(icon, size: 48, color: const Color(0xFF036666)),
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
}
