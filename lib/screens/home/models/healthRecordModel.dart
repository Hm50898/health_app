class HealthRecord {
  List<ConditionsSummary> conditionsSummary;
  List<LabTestsSummary> labTestsSummary;
  List<MedicalImagesSummary> medicalImagesSummary;
  List<MedicinesSummary> medicinesSummary;
  List<PrescriptionsSummary> prescriptionsSummary;
  List<EncountersSummary> encountersSummary;

  HealthRecord({
    required this.conditionsSummary,
    required this.labTestsSummary,
    required this.medicalImagesSummary,
    required this.medicinesSummary,
    required this.prescriptionsSummary,
    required this.encountersSummary,
  });
}

class ConditionsSummary {
  int conditionId;
  ConditionName conditionName;
  DateTime date;
  Severity severity;
  String note;

  ConditionsSummary({
    required this.conditionId,
    required this.conditionName,
    required this.date,
    required this.severity,
    required this.note,
  });
}

enum ConditionName {
  CANCER,
  CKD,
  DIABETES,
  FEAVER,
  HYPERTENSION,
  SKIN_CANCER,
  UNKNOWN
}

enum Severity { MILD, MODERATE, SEVERE }

class EncountersSummary {
  int encounterId;
  ConditionName conditionName;
  DateTime encounterDate;

  EncountersSummary({
    required this.encounterId,
    required this.conditionName,
    required this.encounterDate,
  });
}

class LabTestsSummary {
  int labTestId;
  TestName testName;
  DateTime testDate;
  Result result;
  Note note;

  LabTestsSummary({
    required this.labTestId,
    required this.testName,
    required this.testDate,
    required this.result,
    required this.note,
  });
}

enum Note { ALL_NORAML, NO_NOTES_AVAILABLE }

enum Result { NORMAL }

enum TestName { CBC }

class MedicalImagesSummary {
  int medicalImageId;
  String medicalImageName;
  String medicalImageDate;

  MedicalImagesSummary({
    required this.medicalImageId,
    required this.medicalImageName,
    required this.medicalImageDate,
  });
}

class MedicinesSummary {
  int patientMedicineId;
  Name name;
  DateTime date;
  String dosePerTime;
  int durationInDays;
  int frequencyInHours;
  bool isOngoing;

  MedicinesSummary({
    required this.patientMedicineId,
    required this.name,
    required this.date,
    required this.dosePerTime,
    required this.durationInDays,
    required this.frequencyInHours,
    required this.isOngoing,
  });
}

enum Name { AUGMENTINE, BRUFEN, PANADOL }

class PrescriptionsSummary {
  int prescriptionId;
  DateTime prescriptionDate;
  Publisher publisher;
  ConditionName conditionName;

  PrescriptionsSummary({
    required this.prescriptionId,
    required this.prescriptionDate,
    required this.publisher,
    required this.conditionName,
  });
}

enum Publisher { DR_HOSAM, DR_MOHAMED_ABDULGHANY, MOHAMED_ABDULGHANY }
