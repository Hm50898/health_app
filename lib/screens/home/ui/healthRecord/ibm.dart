import 'package:flutter/material.dart';
import 'package:flutter_project/screens/home/models/health_record_model.dart';

class IBMPage extends StatelessWidget {
  final List<List<Encounter>> encountersSummary;

  const IBMPage({super.key, required this.encountersSummary});

  @override
  Widget build(BuildContext context) {
    final allEncounters = encountersSummary.expand((x) => x).toList();

    // Group encounters by condition
    final Map<String, List<Encounter>> groupedEncounters = {};
    for (var encounter in allEncounters) {
      if (!groupedEncounters.containsKey(encounter.conditionName)) {
        groupedEncounters[encounter.conditionName] = [];
      }
      groupedEncounters[encounter.conditionName]!.add(encounter);
    }

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
                "IBM Analysis",
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
          itemCount: groupedEncounters.length,
          itemBuilder: (context, index) {
            final conditionName = groupedEncounters.keys.elementAt(index);
            final encounters = groupedEncounters[conditionName]!;

            return Card(
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
                    Text(
                      conditionName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF036666),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...encounters
                        .map((encounter) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Encounter #${encounter.encounterId}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    encounter.encounterDate
                                        .toString()
                                        .split(' ')[0],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    const SizedBox(height: 8),
                    Text(
                      'Total Encounters: ${encounters.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
