// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';

class GadScreen extends StatefulWidget {
  const GadScreen({super.key});

  @override
  _GadScreenState createState() => _GadScreenState();
}

class _GadScreenState extends State<GadScreen> {
  final List<String> questions = [
    'Feeling nervous, anxious, or on edge',
    'Not being able to stop or control worrying',
    'Worrying too much about different things',
    'Trouble relaxing',
    'Being so restless that it is hard to sit still',
    'Becoming easily annoyed or irritable',
    'Feeling afraid as if something awful might happen'
  ];

  final List<String> options = [
    'a) Not at all',
    'b) Several days',
    'c) More than half the days',
    'd) Nearly every day',
  ];

  Map<int, int> answers = {};
  String? lastResultText;
  int? lastScore;

  int calculateTotalScore() {
    int score = 0;
    answers.forEach((key, value) {
      score += value;
    });
    return score;
  }

  String interpretScore(int score) {
    if (score >= 0 && score <= 4) {
      return "Minimal anxiety";
    } else if (score >= 5 && score <= 9)
      return "Mild anxiety";
    else if (score >= 10 && score <= 14)
      return "Moderate anxiety";
    else if (score >= 15 && score <= 21)
      return "Severe anxiety";
    else
      return "Invalid score";
  }

  void showScoreDialog(int score) {
    String result = interpretScore(score);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Assessment Result',
            style: TextStyle(color: Colors.teal),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.assessment, color: Colors.teal, size: 60),
            const SizedBox(height: 16),
            Text(
              result,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.teal)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.teal),
        title: const Text(
          'GAD-7',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.teal),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is MentalHealthAssessmentSuccess) {
              if (lastScore != null) {
                showScoreDialog(lastScore!);
              }
            } else if (state is MentalHealthAssessmentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'Over the last 2 weeks, how often have you been bothered by the following problems?',
                  style: TextStyle(
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questions[index],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: List.generate(4, (optionIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      answers[index] = optionIndex;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: answers[index] == optionIndex
                                            ? Colors.teal
                                            : Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: answers[index] == optionIndex
                                          ? Colors.teal.withOpacity(0.15)
                                          : Colors.grey.shade100,
                                    ),
                                    child: Text(options[optionIndex]),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (answers.length < questions.length) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please answer all questions first'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      int score = calculateTotalScore();
                      // احفظ نتيجة التقييم النصية والرقمية
                      lastResultText = interpretScore(score);
                      lastScore = score;
                      // إرسال النتيجة إلى السيرفر
                      context.read<HomeCubit>().postMentalHealthAssessment(
                            assessmentType: 2, // GAD
                            score: score,
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
