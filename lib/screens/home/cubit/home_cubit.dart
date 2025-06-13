import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/screens/home/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  bool showButtons = false;
  int selectedIndex = 0;

  void toggleButtonsVisibility() {
    showButtons = !showButtons;
    emit(HomeButtonsVisibilityChanged(showButtons));
  }

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    emit(HomeIndexChanged(selectedIndex));
  }
}
