abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeButtonsVisibilityChanged extends HomeState {
  final bool showButtons;
  HomeButtonsVisibilityChanged(this.showButtons);
}

class HomeIndexChanged extends HomeState {
  final int selectedIndex;
  HomeIndexChanged(this.selectedIndex);
}

class DashboardLoading extends HomeState {}

class DashboardLoaded extends HomeState {
  final Map<String, dynamic> dashboardData;
  DashboardLoaded(this.dashboardData);
}

class DashboardError extends HomeState {
  final String message;
  DashboardError(this.message);
}
