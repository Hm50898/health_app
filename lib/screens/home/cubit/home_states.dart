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
