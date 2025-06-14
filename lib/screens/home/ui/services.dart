import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';
import 'package:flutter_project/screens/home/ui/prescription.dart';

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
                            () {
                              // Navigate to Medicine page
                            },
                          ),
                          _buildServiceCard(
                            'BMI',
                            'images/Primary (3).png',
                            () {
                              // Navigate to BMI page
                            },
                          ),
                          _buildServiceCard(
                            'Disease',
                            'images/Primary (4).png',
                            () {
                              // Navigate to Disease page
                            },
                          ),
                          _buildServiceCard(
                            'Lab',
                            'images/lab.png',
                            () {
                              // Navigate to Lab page
                            },
                          ),
                          _buildServiceCard(
                            'Imaging',
                            'images/Imaging.png',
                            () {
                              // Navigate to Imaging page
                            },
                          ),
                          _buildServiceCard(
                            'Prescription',
                            'images/Prescription.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrescriptionPage(),
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

  Widget _buildServiceCard(String title, String imagePath, VoidCallback onTap) {
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
          ],
        ),
      ),
    );
  }
}
