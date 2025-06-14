import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../cosntants.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  bool _isButtonsVisible = true;
  int _selectedIndex = 0;

  bool get isButtonsVisible => _isButtonsVisible;
  int get selectedIndex => _selectedIndex;

  void toggleButtonsVisibility() {
    _isButtonsVisible = !_isButtonsVisible;
    emit(HomeButtonsVisibilityChanged(_isButtonsVisible));
  }

  void changeIndex(int index) {
    _selectedIndex = index;
    emit(HomeIndexChanged(_selectedIndex));
  }

  Future<void> getDashboardData() async {
    try {
      emit(DashboardLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        emit(DashboardError('No token found'));
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Patient/GetPatientDashboard?patientId=1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Dashboard Data: $data'); // Debug print
        emit(DashboardLoaded(data));
      } else {
        emit(DashboardError('Failed to load dashboard data'));
      }
    } catch (e) {
      debugPrint('Error in getDashboardData: $e'); // Debug print
      emit(DashboardError(e.toString()));
    }
  }
}
