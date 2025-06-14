import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_project/screens/setting/cubit/setting_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project/cosntants.dart';
import 'package:flutter/foundation.dart';

// Cubit
class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      emit(ChangePasswordLoading());

      // Get the stored token and decode it to get userId
      final prefs = await SharedPreferences.getInstance();
      debugPrint('Attempting to get token with key: $tokenKey');
      final token = prefs.getString(tokenKey);
      debugPrint(
          'Retrieved token: ${token != null ? 'Token exists' : 'Token is null'}');

      if (token == null) {
        throw Exception('No token found');
      }

      // Decode the token to get userId
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token format');
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final decodedToken = json.decode(decoded);
      debugPrint('Decoded token: $decodedToken');
      final userId = decodedToken['sub'];
      debugPrint('Extracted userId: $userId');

      // Make the API call
      final response = await http.post(
        Uri.parse('$baseUrl/Account/resetpassword'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'ApplicationUserId': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        emit(ChangePasswordSuccess());
      } else {
        final errorData = json.decode(response.body);
        emit(ChangePasswordError(
            errorData['message'] ?? 'Failed to change password'));
      }
    } catch (e) {
      debugPrint('Error in changePassword: $e');
      emit(ChangePasswordError(e.toString()));
    }
  }
}
