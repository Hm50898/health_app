import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';
import 'dart:io';

class LabTestDetailsScreen extends StatefulWidget {
  final int labTestId;

  const LabTestDetailsScreen({
    Key? key,
    required this.labTestId,
  }) : super(key: key);

  @override
  State<LabTestDetailsScreen> createState() => _LabTestDetailsScreenState();
}

class _LabTestDetailsScreenState extends State<LabTestDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getLabTestDetails(widget.labTestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التحليل'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is LabTestDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LabTestDetailsLoaded) {
            final data = state.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailCard(
                    title: 'اسم المريض',
                    value: data['patientName'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    title: 'الرقم القومي',
                    value: data['patientNationalId'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    title: 'اسم التحليل',
                    value: data['labTestName'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    title: 'تاريخ التحليل',
                    value: data['labTestDate'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  if (data['labTestImageUrl'] != null) ...[
                    Center(
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: const Color(0xFF036666), width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (state is ImageDownloadLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is ImageDownloadLoaded) {
                                return Image.file(
                                  File(state.imagePath),
                                  fit: BoxFit.cover,
                                );
                              } else if (state is ImageDownloadError) {
                                return Center(child: Text(state.message));
                              }
                              return const Center(
                                  child: Text('No image available'));
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (data['resultes'] != null) ...[
                    const Text(
                      'النتائج',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF036666),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      (data['resultes'] as List).length,
                      (index) {
                        final result = data['resultes'][index];
                        return _buildDetailCard(
                          title: result['attributeName'] ?? '',
                          value: result['value']?.toString() ?? '',
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          } else if (state is LabTestDetailsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
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
