import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final int prescriptionId;

  const PrescriptionDetailsScreen({
    Key? key,
    required this.prescriptionId,
  }) : super(key: key);

  @override
  State<PrescriptionDetailsScreen> createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getPrescriptionDetails(widget.prescriptionId);
  }

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
                "تفاصيل الوصفة",
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is PrescriptionDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrescriptionDetailsLoaded) {
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
                    title: 'تاريخ الوصفة',
                    value: data['prescriptionDate'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    title: 'التشخيص',
                    value: data['diseaseName'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  if (data['medicines'] != null) ...[
                    const Text(
                      'الأدوية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF036666),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      (data['medicines'] as List).length,
                      (index) {
                        final medicine = data['medicines'][index];
                        return _buildDetailCard(
                          title: medicine['name'] ?? '',
                          value:
                              '${medicine['dose'] ?? ''} - كل ${medicine['frequencyInHours'] ?? ''} ساعة - لمدة ${medicine['durationInDays'] ?? ''} يوم',
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          } else if (state is PrescriptionDetailsError) {
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
