import 'package:flutter/material.dart';

class HypertensionReportPage extends StatelessWidget {
  const HypertensionReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF036666), width: 2),
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF036666), size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Report',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF036666),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مرض + أيقونة
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.favorite, color: Color(0xFF036666), size: 32),
                title: const Text(
                  'Hypertension (High Blood Pressure)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF036666),
                  ),
                ),
                subtitle: const Text(
                  'Chronic condition where blood pressure is elevated.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '🩺 Medical Summary',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF036666),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Blood pressure readings are consistently above the normal range.\n'
                          '• Symptoms may include headaches, dizziness, or fatigue.\n'
                          '• Risk factors: stress, salt intake, obesity, smoking.\n'
                          '• Regular medication is needed to manage the condition.\n'
                          '• Complications may include stroke or heart attack.',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85, // 85% من عرض الشاشة
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.teal.shade100.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '📋 Recommendations',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF036666),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '🍽️ Reduce salt and processed food intake\n'
                              '🏃‍♀️ Exercise 30 minutes daily\n'
                              '💊 Take prescribed medication regularly\n'
                              '🧘‍♀️ Reduce stress through relaxation\n'
                              '🩸 Monitor blood pressure at home\n'
                              '🚭 Avoid smoking and limit caffeine',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
