import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/home/cubit/home_cubit.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';

class GeneralHealth extends StatelessWidget {
  const GeneralHealth({super.key});

  Widget buildCard({
    required String title,
    required String value,
    required String status,
    required Widget iconWidget,
    required Color textColor,
    required Color indicatorColor,
    BoxDecoration? decoration,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: decoration ??
          BoxDecoration(
            border: Border.all(color: const Color(0xFF036666)),
            borderRadius: BorderRadius.circular(12),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: iconWidget,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          status == "" ? const SizedBox() : const SizedBox(height: 10),
          status == ""
              ? const SizedBox()
              : Row(
                  children: [
                    // Icon(
                    //   status.contains("Higher")
                    //       ? Icons.arrow_upward_rounded
                    //       : Icons.arrow_downward_rounded,
                    //   color: indicatorColor,
                    //   size: 20,
                    // ),
                    // const SizedBox(width: 1),
                    Text(
                      status,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildBloodPressure(String label, Color color, List readings) {
    // تحديد أقصى قيمة لعمل مقياس نسبي للارتفاع
    double maxValue = 1;
    if (readings.isNotEmpty) {
      maxValue = readings
          .map((e) => (e['hemoglobinValue'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(readings.length, (index) {
          final reading = readings[index];
          final value = (reading['hemoglobinValue'] as num).toDouble();
          final date = reading['date'] as String;
          // استخراج الشهر واليوم فقط
          String shortDate = '';
          try {
            final parts = date.split('-');
            if (parts.length == 3) {
              shortDate = '${parts[1]}-${parts[2]}';
            } else {
              shortDate = date;
            }
          } catch (_) {
            shortDate = date;
          }
          // تحديد ارتفاع العمود بناءً على القيمة (مثلاً: 70 هو أقصى ارتفاع)
          double minBarHeight = 20;
          double maxBarHeight = 70;
          double barHeight = minBarHeight +
              ((value / maxValue) * (maxBarHeight - minBarHeight));
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Container(
                width: 16,
                height: barHeight,
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? color : Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                shortDate,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildBloodRangeCard(
    String label,
    String value,
    Color bgColor,
    Color textColor, {
    required Widget iconWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF036666)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: iconWidget,
              ),
              const SizedBox(width: 7),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: textColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getDashboardData(),
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
                  "General Health",
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
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardError) {
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
                          context.read<HomeCubit>().getDashboardData();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardLoaded) {
                final data = state.data;

                // Extract values from the new data structure
                final bloodPressure =
                    '${data['bloodPressure']['averageSystolic']}/${data['bloodPressure']['averageDiastolic']}';
                final bloodPressureStatus =
                    data['bloodPressure']['isNormal'] ? '' : 'Not Normal';

                final glucoseLevel = '${data['glucose']['average']}';
                final glucoseStatus =
                    data['glucose']['isNormal'] ? '' : 'Not Normal';

                final heartRate = '${data['heartRate']['average']}';
                final heartRateStatus =
                    data['heartRate']['isNormal'] ? '' : 'Not Normal';

                final lowestBloodPressure =
                    data['lowestBloodPressure'] ?? '170/80';
                final highestBloodPressure =
                    data['highestBloodPressure'] ?? '170/80';

                // Get the latest hemoglobin reading
                final hemoglobinReadings =
                    data['hemoglobin']['hemoglobinReadings'] as List;
                final latestHemoglobin = hemoglobinReadings.isNotEmpty
                    ? hemoglobinReadings[0]['hemoglobinValue'].toString()
                    : '10.5';

                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: buildCard(
                              title: 'Blood Status',
                              value: bloodPressure,
                              status: bloodPressureStatus,
                              iconWidget: Image.asset(
                                'images/dropblood.png',
                                width: 24,
                                height: 24,
                              ),
                              textColor: Colors.black54,
                              indicatorColor: data['bloodPressure']['isNormal']
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildCard(
                              title: 'Glucose Level',
                              value: glucoseLevel,
                              status: glucoseStatus,
                              iconWidget: Image.asset(
                                'images/glucose level.png',
                                width: 24,
                                height: 24,
                              ),
                              textColor: Colors.black54,
                              indicatorColor: data['glucose']['isNormal']
                                  ? Colors.green
                                  : Colors.red,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFFE0FFFF),
                                    Color(0xFFFFFFFF)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFF036666)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: buildCard(
                              title: 'Heart Rate',
                              value: '$heartRate bmp',
                              status: heartRateStatus,
                              iconWidget: Image.asset(
                                'images/heart rate.png',
                                width: 24,
                                height: 24,
                              ),
                              textColor: Colors.black54,
                              indicatorColor: data['heartRate']['isNormal']
                                  ? Colors.green
                                  : Colors.red,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFFFFC8C8),
                                    Color(0xFFFFFFFF)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFF036666)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                buildBloodRangeCard(
                                  'Lowest Blood Pressure',
                                  lowestBloodPressure,
                                  Colors.white,
                                  const Color(0xFF036666),
                                  iconWidget: Image.asset(
                                      'images/healthicons_low-bars-outline.png'),
                                ),
                                const SizedBox(height: 12),
                                buildBloodRangeCard(
                                  'Highest Blood Pressure',
                                  highestBloodPressure,
                                  const Color(0xFF004D47),
                                  const Color(0xB0FFFFFF),
                                  iconWidget: Image.asset(
                                      'images/healthicons_high-bars-outline.png'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF036666)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildBloodPressure(
                                "Blood Pressure",
                                Colors.orange,
                                data['hemoglobin']['hemoglobinReadings']
                                    as List),
                            const SizedBox(height: 10),
                            const Text(
                              'Hemoglobin',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$latestHemoglobin mg/dl',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
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
}
