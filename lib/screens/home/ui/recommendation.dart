import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  bool _showRecommendation = false;
  Map<String, dynamic>? edEngineData;

  final List<String> diseases = [
    "Anemia",
    "Diabetes",
    "Hypertension",
    "Chronic Kidney Disease",
    "Heart Disease",
  ];

  final Map<String, String> diseaseKeys = {
    "Anemia": "animea",
    "Diabetes": "diabetes",
    "Hypertension": "hypertenstion",
    "Chronic Kidney Disease": "chronicKidneyDisease",
    "Heart Disease": "heartDisease",
  };

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
                child: const Icon(Icons.arrow_back,
                    color: Color(0xFF036666), size: 20),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Recommendation',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF036666),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.notifications_none, color: Color(0xFF036666)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: _showRecommendation
              ? BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is EDEngineCheckLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EDEngineCheckLoaded) {
                      edEngineData = state.data;
                    } else if (state is EDEngineCheckError) {
                      return Center(
                          child: Text(state.message,
                              style: TextStyle(color: Colors.red)));
                    }
                    return Column(
                      key: const ValueKey('disease_list'),
                      children: [
                        const Spacer(flex: 2),
                        const Text(
                          'Detected Conditions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF036666),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ...diseases.map((disease) {
                          String key = diseaseKeys[disease] ?? '';
                          bool? value = edEngineData != null && key.isNotEmpty
                              ? edEngineData![key] as bool?
                              : null;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.teal.shade200),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    disease,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF036666),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xFF036666), size: 18),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFF036666)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    value == null
                                        ? '--'
                                        : (value ? 'Yes' : 'No'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF036666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Spacer(flex: 3),
                      ],
                    );
                  },
                )
              : Column(
                  key: const ValueKey('initial_content'),
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'images/recommend.png',
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Check your health\nGet recommendations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF036666),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF036666),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _showRecommendation = true;
                          });
                          context.read<HomeCubit>().getEDEngineCheck();
                        },
                        child: const Text(
                          'Examine',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
