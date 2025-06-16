import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../cosntants.dart';
import 'home_states.dart';
import 'package:path_provider/path_provider.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  bool _isButtonsVisible = false;
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
      final patientId = decodedToken['PatientId'] ?? 1;

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

  Future<void> getLabTestDetails(int labTestId) async {
    try {
      emit(LabTestDetailsLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        emit(LabTestDetailsError('No token found'));
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/HealthRecord/lab-test-details/$labTestId'),
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
        debugPrint('Lab Test Details Data: $data');
        emit(LabTestDetailsLoaded(data));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to load lab test details';
        emit(LabTestDetailsError(errorMessage));
      }
    } on TimeoutException {
      emit(LabTestDetailsError('Request timed out. Please try again.'));
    } on SocketException {
      emit(LabTestDetailsError(
          'No internet connection. Please check your connection.'));
    } catch (e) {
      debugPrint('Error in getLabTestDetails: $e');
      emit(LabTestDetailsError(
          'Failed to load lab test details. Please try again.'));
    }
  }

  Future<void> getMedicalImageDetails(int imageId) async {
    try {
      emit(MedicalImageDetailsLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        emit(MedicalImageDetailsError('No token found'));
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/HealthRecord/medical-image-details/$imageId'),
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
        debugPrint('Medical Image Details Data: $data');
        emit(MedicalImageDetailsLoaded(data));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to load medical image details';
        emit(MedicalImageDetailsError(errorMessage));
      }
    } on TimeoutException {
      emit(MedicalImageDetailsError('Request timed out. Please try again.'));
    } on SocketException {
      emit(MedicalImageDetailsError(
          'No internet connection. Please check your connection.'));
    } catch (e) {
      debugPrint('Error in getMedicalImageDetails: $e');
      emit(MedicalImageDetailsError(
          'Failed to load medical image details. Please try again.'));
    }
  }

  Future<void> getPrescriptionDetails(int prescriptionId) async {
    try {
      emit(PrescriptionDetailsLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        emit(PrescriptionDetailsError('No token found'));
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/HealthRecord/prescription-details/$prescriptionId'),
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
        debugPrint('Prescription Details Data: $data');
        emit(PrescriptionDetailsLoaded(data));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to load prescription details';
        emit(PrescriptionDetailsError(errorMessage));
      }
    } on TimeoutException {
      emit(PrescriptionDetailsError('Request timed out. Please try again.'));
    } on SocketException {
      emit(PrescriptionDetailsError(
          'No internet connection. Please check your connection.'));
    } catch (e) {
      debugPrint('Error in getPrescriptionDetails: $e');
      emit(PrescriptionDetailsError(
          'Failed to load prescription details. Please try again.'));
    }
  }

  Future<void> downloadImage(String filePath) async {
    try {
      emit(ImageDownloadLoading());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        emit(ImageDownloadError('No token found'));
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Document/download-file?filePath=$filePath'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        // Get the application documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = filePath.split('/').last;
        final file = File('${appDir.path}/$fileName');

        // Write the image data to a file
        await file.writeAsBytes(response.bodyBytes);

        debugPrint('Image downloaded successfully to: ${file.path}');
        emit(ImageDownloadLoaded(file.path));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to download image';
        emit(ImageDownloadError(errorMessage));
      }
    } on TimeoutException {
      emit(ImageDownloadError('Request timed out. Please try again.'));
    } on SocketException {
      emit(ImageDownloadError(
          'No internet connection. Please check your connection.'));
    } catch (e) {
      debugPrint('Error in downloadImage: $e');
      emit(ImageDownloadError('Failed to download image. Please try again.'));
    }
  }
}
