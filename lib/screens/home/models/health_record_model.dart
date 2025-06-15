class HealthRecordModel {
  final int patientId;
  final List<Medicine> medicines;
  final List<Disease> diseases;
  final List<LabTest> labTests;
  final List<Imaging> imaging;
  final List<Prescription> prescriptions;
  final BMIData? bmiData;

  HealthRecordModel({
    required this.patientId,
    required this.medicines,
    required this.diseases,
    required this.labTests,
    required this.imaging,
    required this.prescriptions,
    this.bmiData,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      patientId: json['patientId'] ?? 0,
      medicines: (json['medicines'] as List?)
              ?.map((e) => Medicine.fromJson(e))
              .toList() ??
          [],
      diseases: (json['diseases'] as List?)
              ?.map((e) => Disease.fromJson(e))
              .toList() ??
          [],
      labTests: (json['labTests'] as List?)
              ?.map((e) => LabTest.fromJson(e))
              .toList() ??
          [],
      imaging: (json['imaging'] as List?)
              ?.map((e) => Imaging.fromJson(e))
              .toList() ??
          [],
      prescriptions: (json['prescriptions'] as List?)
              ?.map((e) => Prescription.fromJson(e))
              .toList() ??
          [],
      bmiData:
          json['bmiData'] != null ? BMIData.fromJson(json['bmiData']) : null,
    );
  }
}

class Medicine {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}

class Disease {
  final int id;
  final String name;
  final String diagnosis;
  final DateTime diagnosisDate;
  final String status;

  Disease({
    required this.id,
    required this.name,
    required this.diagnosis,
    required this.diagnosisDate,
    required this.status,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      diagnosisDate: DateTime.parse(json['diagnosisDate']),
      status: json['status'] ?? '',
    );
  }
}

class LabTest {
  final int id;
  final String name;
  final String result;
  final DateTime testDate;
  final String status;

  LabTest({
    required this.id,
    required this.name,
    required this.result,
    required this.testDate,
    required this.status,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      result: json['result'] ?? '',
      testDate: DateTime.parse(json['testDate']),
      status: json['status'] ?? '',
    );
  }
}

class Imaging {
  final int id;
  final String type;
  final String result;
  final DateTime scanDate;
  final String status;

  Imaging({
    required this.id,
    required this.type,
    required this.result,
    required this.scanDate,
    required this.status,
  });

  factory Imaging.fromJson(Map<String, dynamic> json) {
    return Imaging(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      result: json['result'] ?? '',
      scanDate: DateTime.parse(json['scanDate']),
      status: json['status'] ?? '',
    );
  }
}

class Prescription {
  final int id;
  final String doctorName;
  final DateTime prescriptionDate;
  final List<Medicine> medicines;
  final String notes;

  Prescription({
    required this.id,
    required this.doctorName,
    required this.prescriptionDate,
    required this.medicines,
    required this.notes,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      prescriptionDate: DateTime.parse(json['prescriptionDate']),
      medicines: (json['medicines'] as List?)
              ?.map((e) => Medicine.fromJson(e))
              .toList() ??
          [],
      notes: json['notes'] ?? '',
    );
  }
}

class BMIData {
  final double height;
  final double weight;
  final double bmi;
  final String category;
  final DateTime measurementDate;

  BMIData({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.category,
    required this.measurementDate,
  });

  factory BMIData.fromJson(Map<String, dynamic> json) {
    return BMIData(
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      bmi: (json['bmi'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      measurementDate: DateTime.parse(json['measurementDate']),
    );
  }
}
