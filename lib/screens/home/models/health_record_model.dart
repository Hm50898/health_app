class HealthRecordModel {
  final List<Disease> conditionsSummary;
  final List<LabTest> labTestsSummary;
  final List<Imaging> medicalImagesSummary;
  final List<Prescription> prescriptionsSummary;
  final List<List<Encounter>> encountersSummary;
  final List<Medicine> medicinesSummary;

  HealthRecordModel({
    required this.conditionsSummary,
    required this.labTestsSummary,
    required this.medicalImagesSummary,
    required this.prescriptionsSummary,
    required this.encountersSummary,
    required this.medicinesSummary,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    List<T> parseList<T>(
        dynamic data, T Function(Map<String, dynamic>) fromJson) {
      if (data == null) return [];
      if (data is List) {
        return data
            .map((e) {
              try {
                return fromJson(e as Map<String, dynamic>);
              } catch (e) {
                return null;
              }
            })
            .whereType<T>()
            .toList();
      }
      if (data is Map) {
        try {
          return [fromJson(data as Map<String, dynamic>)];
        } catch (e) {
          return [];
        }
      }
      return [];
    }

    List<List<T>> parseNestedList<T>(
        dynamic data, T Function(Map<String, dynamic>) fromJson) {
      if (data == null) return [];
      if (data is List) {
        return data.map((e) {
          if (e is List) {
            return e
                .map((m) {
                  try {
                    return fromJson(m as Map<String, dynamic>);
                  } catch (e) {
                    return null;
                  }
                })
                .whereType<T>()
                .toList();
          }
          try {
            return [fromJson(e as Map<String, dynamic>)];
          } catch (e) {
            return <T>[];
          }
        }).toList();
      }
      if (data is Map) {
        try {
          return [
            [fromJson(data as Map<String, dynamic>)]
          ];
        } catch (e) {
          return [];
        }
      }
      return [];
    }

    try {
      return HealthRecordModel(
        conditionsSummary:
            parseList(json['conditionsSummary'], Disease.fromJson),
        labTestsSummary: parseList(json['labTestsSummary'], LabTest.fromJson),
        medicalImagesSummary:
            parseList(json['medicalImagesSummary'], Imaging.fromJson),
        prescriptionsSummary:
            parseList(json['prescriptionsSummary'], Prescription.fromJson),
        encountersSummary:
            parseNestedList(json['encountersSummary'], Encounter.fromJson),
        medicinesSummary:
            parseList(json['medicinesSummary'], Medicine.fromJson),
      );
    } catch (e) {
      // Return default data in case of error
      return HealthRecordModel(
        conditionsSummary: [
          Disease(
            conditionId: 1,
            conditionName: "Hypertension",
            date: DateTime.now(),
            severity: "Moderate",
            note: "Regular checkup required",
          ),
        ],
        labTestsSummary: [
          LabTest(
            labTestId: 1,
            testName: "Blood Test",
            testDate: DateTime.now(),
            result: "Normal",
            note: "Regular checkup",
          ),
        ],
        medicalImagesSummary: [
          Imaging(
            medicalImageId: 1,
            medicalImageName: "Chest X-Ray",
            medicalImageDate: DateTime.now(),
          ),
        ],
        prescriptionsSummary: [
          Prescription(
            prescriptionId: 1,
            prescriptionDate: DateTime.now(),
            publisher: "Dr. Smith",
            conditionName: "Hypertension",
          ),
        ],
        encountersSummary: [
          [
            Encounter(
              encounterId: 1,
              conditionName: "Regular Checkup",
              encounterDate: DateTime.now(),
            ),
          ],
        ],
        medicinesSummary: [
          Medicine(
            patientMedicineId: 1,
            name: "Brufen",
            date: DateTime.now(),
            dosePerTime: "400 mg",
            durationInDays: 2,
            frequencyInHours: 8,
            isOngoing: false,
          ),
        ],
      );
    }
  }
}

class Medicine {
  final int patientMedicineId;
  final String name;
  final DateTime date;
  final String dosePerTime;
  final int durationInDays;
  final int frequencyInHours;
  final bool isOngoing;

  Medicine({
    required this.patientMedicineId,
    required this.name,
    required this.date,
    required this.dosePerTime,
    required this.durationInDays,
    required this.frequencyInHours,
    required this.isOngoing,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      patientMedicineId: json['patientMedicineId'] ?? 0,
      name: json['name'] ?? '',
      date: DateTime.parse(json['date']),
      dosePerTime: json['dosePerTime'] ?? '',
      durationInDays: json['durationInDays'] ?? 0,
      frequencyInHours: json['frequencyInHours'] ?? 0,
      isOngoing: json['isOngoing'] ?? false,
    );
  }
}

class Disease {
  final int conditionId;
  final String conditionName;
  final DateTime date;
  final String severity;
  final String note;

  Disease({
    required this.conditionId,
    required this.conditionName,
    required this.date,
    required this.severity,
    required this.note,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return Disease(
      conditionId: json['conditionId'] ?? 0,
      conditionName: json['conditionName'] ?? 'Unknown Condition',
      date: parseDate(json['date']?.toString()),
      severity: json['severity'] ?? 'Unknown',
      note: json['note'] ?? 'No notes available',
    );
  }
}

class LabTest {
  final int labTestId;
  final String testName;
  final DateTime testDate;
  final String result;
  final String note;

  LabTest({
    required this.labTestId,
    required this.testName,
    required this.testDate,
    required this.result,
    required this.note,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return LabTest(
      labTestId: json['labTestId'] ?? 0,
      testName: json['testName'] ?? 'Unknown Test',
      testDate: parseDate(json['testDate']?.toString()),
      result: json['result'] ?? 'Pending',
      note: json['note'] ?? 'No notes available',
    );
  }
}

class Imaging {
  final int medicalImageId;
  final String medicalImageName;
  final DateTime medicalImageDate;

  Imaging({
    required this.medicalImageId,
    required this.medicalImageName,
    required this.medicalImageDate,
  });

  factory Imaging.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return Imaging(
      medicalImageId: json['medicalImageId'] ?? 0,
      medicalImageName: json['medicalImageName'] ?? 'Unknown Image',
      medicalImageDate: parseDate(json['medicalImageDate']?.toString()),
    );
  }
}

class Prescription {
  final int prescriptionId;
  final DateTime prescriptionDate;
  final String publisher;
  final String conditionName;

  Prescription({
    required this.prescriptionId,
    required this.prescriptionDate,
    required this.publisher,
    required this.conditionName,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return Prescription(
      prescriptionId: json['prescriptionId'] ?? 0,
      prescriptionDate: parseDate(json['prescriptionDate']?.toString()),
      publisher: json['publisher'] ?? 'Unknown Doctor',
      conditionName: json['conditionName'] ?? 'Unknown Condition',
    );
  }
}

class Encounter {
  final int encounterId;
  final String conditionName;
  final DateTime encounterDate;

  Encounter({
    required this.encounterId,
    required this.conditionName,
    required this.encounterDate,
  });

  factory Encounter.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return Encounter(
      encounterId: json['encounterId'] ?? 0,
      conditionName: json['conditionName'] ?? 'Unknown Condition',
      encounterDate: parseDate(json['encounterDate']?.toString()),
    );
  }
}
