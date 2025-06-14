import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
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

  Future<void> getHealthRecordSummary() async {
    try {
      emit(HealthRecordSummaryLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        emit(HealthRecordSummaryError('No token found'));
        return;
      }

      // Decode the token to get patientId
      final parts = token.split('.');
      if (parts.length != 3) {
        emit(HealthRecordSummaryError('Invalid token format'));
        return;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final decodedToken = json.decode(decoded);
      final patientId = decodedToken['PatientId'];

      final response = await http.get(
        Uri.parse('$baseUrl/HealthRecord/Summary/$patientId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Health Record Summary Data: $data');
        emit(HealthRecordSummaryLoaded(data));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to load health record summary';
        emit(HealthRecordSummaryError(errorMessage));
      }
    } on TimeoutException {
      emit(HealthRecordSummaryError('Request timed out. Please try again.'));
    } on SocketException {
      emit(HealthRecordSummaryError(
          'No internet connection. Please check your connection.'));
    } catch (e) {
      debugPrint('Error in getHealthRecordSummary: $e');
      emit(HealthRecordSummaryError(
          'Failed to load health record summary. Please try again.'));
    }
  }
}
