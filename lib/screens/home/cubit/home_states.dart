abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeButtonsVisibilityChanged extends HomeState {
  final bool isVisible;

  HomeButtonsVisibilityChanged(this.isVisible);
}

class HomeIndexChanged extends HomeState {
  final int index;

  HomeIndexChanged(this.index);
}

class DashboardLoading extends HomeState {}

class DashboardLoaded extends HomeState {
  final Map<String, dynamic> data;

  DashboardLoaded(this.data);
}

class DashboardError extends HomeState {
  final String message;

  DashboardError(this.message);
}

class HealthRecordSummaryLoading extends HomeState {}

class HealthRecordSummaryLoaded extends HomeState {
  final Map<String, dynamic> data;

  HealthRecordSummaryLoaded(this.data);
}

class HealthRecordSummaryError extends HomeState {
  final String message;

  HealthRecordSummaryError(this.message);
}

class LabTestDetailsLoading extends HomeState {}

class LabTestDetailsLoaded extends HomeState {
  final Map<String, dynamic> data;

  LabTestDetailsLoaded(this.data);
}

class LabTestDetailsError extends HomeState {
  final String message;

  LabTestDetailsError(this.message);
}

class MedicalImageDetailsLoading extends HomeState {}

class MedicalImageDetailsLoaded extends HomeState {
  final Map<String, dynamic> data;

  MedicalImageDetailsLoaded(this.data);
}

class MedicalImageDetailsError extends HomeState {
  final String message;

  MedicalImageDetailsError(this.message);
}

class PrescriptionDetailsLoading extends HomeState {}

class PrescriptionDetailsLoaded extends HomeState {
  final Map<String, dynamic> data;

  PrescriptionDetailsLoaded(this.data);
}

class PrescriptionDetailsError extends HomeState {
  final String message;

  PrescriptionDetailsError(this.message);
}

class ImageDownloadLoading extends HomeState {}

class ImageDownloadLoaded extends HomeState {
  final String imagePath;

  ImageDownloadLoaded(this.imagePath);
}

class ImageDownloadError extends HomeState {
  final String message;

  ImageDownloadError(this.message);
}

class MentalHealthAssessmentLoading extends HomeState {}

class MentalHealthAssessmentSuccess extends HomeState {
  final int assessmentType;
  final int score;
  MentalHealthAssessmentSuccess(this.assessmentType, this.score);
}

class MentalHealthAssessmentError extends HomeState {
  final String message;
  MentalHealthAssessmentError(this.message);
}

class EDEngineCheckLoading extends HomeState {}

class EDEngineCheckLoaded extends HomeState {
  final Map<String, dynamic> data;
  EDEngineCheckLoaded(this.data);
}

class EDEngineCheckError extends HomeState {
  final String message;
  EDEngineCheckError(this.message);
}
