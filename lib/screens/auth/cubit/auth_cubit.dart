import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/cosntants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  File? get profileImage => _profileImage;
  String? get token => _token;
  final ImagePicker pickImage = ImagePicker();
  File? _profileImage;
  String? _token;

  Future<void> pickProfileImage() async {
    try {
      final pickedFile = await pickImage.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
        emit(AuthInitialState()); // To rebuild the UI
      }
    } catch (e) {
      emit(AuthErrorState('Failed to pick image: $e'));
    }
  }

  Future<void> initialize() async {
    emit(AuthLoadingState());
    await _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(tokenKey);

      if (_token != null && _token!.isNotEmpty) {
        emit(AuthLoginSuccessState(_token!));
      } else {
        emit(AuthInitialState());
      }
    } catch (e) {
      emit(AuthErrorState('Failed to load token: $e'));
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      if (token.isEmpty) {
        throw Exception('Token cannot be empty');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(tokenKey, token);
      _token = token;
      debugPrint('Token saved successfully');
    } catch (e) {
      emit(AuthErrorState('Failed to save token: $e'));
      rethrow;
    }
  }

  Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      _token = null;
      debugPrint('Token cleared successfully');
    } catch (e) {
      emit(AuthErrorState('Failed to clear token: $e'));
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoadingState());
      await _clearToken();
      emit(AuthLogoutSuccessState());
    } catch (e) {
      emit(AuthErrorState('Logout failed: $e'));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Account/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'stayLoggedIn': true,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        await _saveToken(responseBody['jwtToken']);
        emit(AuthLoginSuccessState(_token!));
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login failed';
        emit(AuthErrorState(error));
      }
    } catch (e) {
      emit(AuthErrorState('Login error: ${e.toString()}'));
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    emit(AuthLoadingState());

    final uri = Uri.parse("$baseUrl/Account/Register");
    try {
      var request = http.MultipartRequest("POST", uri);

      request.fields['first_Name'] = firstName;
      request.fields['last_Name'] = lastName;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['passwordConfirmed'] = confirmPassword;
      request.fields['PhoneNumber'] = phoneNumber;
      request.fields['userType'] = '0';

      // Default profile image (1x1 pixel PNG)
      String defaultImageBase64 =
          "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==";
      request.fields['Image'] = defaultImageBase64;

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        final userId = data['userId'];
        emit(AuthRegisterSuccessState(userId));
      } else {
        final errorData = json.decode(respStr);
        final errorMessage = errorData['message'] ?? 'Registration failed';
        emit(AuthErrorState(errorMessage));
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      emit(AuthErrorState('Registration failed. Please try again.'));
    }
  }

  Future<void> forgetPassword(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      emit(AuthErrorState('Please enter a valid email address'));
      return;
    }

    emit(AuthLoadingState());

    final url = Uri.parse(
      '$baseUrl/Account/send-verification-code?emailAddress=$email',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        emit(AuthForgetPasswordSuccessState(email));
      } else {
        emit(AuthErrorState(
          'Failed to send verification code. Please try again.',
        ));
      }
    } catch (e) {
      emit(AuthErrorState(
        'An error occurred. Please check your internet connection.',
      ));
    }
  }
}
