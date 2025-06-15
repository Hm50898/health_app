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
