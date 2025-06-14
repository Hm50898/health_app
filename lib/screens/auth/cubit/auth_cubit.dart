import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/cosntants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
        final responseBody = jsonDecode(response.body);
        String errorMessage = 'Login failed';

        if (responseBody['errors'] != null &&
            responseBody['errors'].isNotEmpty) {
          final error = responseBody['errors'][0];
          errorMessage = error['description'] ?? errorMessage;
        } else {
          errorMessage = responseBody['message'] ?? errorMessage;
        }

        emit(AuthErrorState(errorMessage));
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

      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Image',
          _profileImage!.path,
        ));
      } else {
        final defaultImage =
            await rootBundle.load('images/add personal photo.png');
        request.files.add(http.MultipartFile.fromBytes(
          'Image',
          defaultImage.buffer.asUint8List(),
          filename: 'default_profile.png',
        ));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(respStr);
        if (data['result'] != null && data['result']['succeeded'] == true) {
          final userId = data['userId'];
          emit(AuthRegisterSuccessState(userId));
        } else {
          final errors = data['result']?['errors'] ?? ['Registration failed'];
          emit(AuthErrorState(errors.first));
        }
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

  Future<void> registerPatient({
    required String nationalId,
    required String nationalIdImageUrl,
    required String birthDate,
    required int gender,
    required String governorate,
    required String city,
    required String applicationUserId,
  }) async {
    emit(AuthLoadingState());

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Patient'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nationalId': nationalId,
          'nationalIdImageUrl': nationalIdImageUrl,
          'birthDate': birthDate,
          'gender': gender,
          'governorate': governorate,
          'city': city,
          'isVerified': false,
          'applicationUserId': applicationUserId,
          'HumanPatient': true,
        }),
      );

      if (response.statusCode == 200) {
        emit(AuthPatientRegisterSuccessState());
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Patient registration failed';
        emit(AuthErrorState(errorMessage));
      }
    } catch (e) {
      debugPrint('Patient registration error: $e');
      emit(AuthErrorState('Patient registration failed. Please try again.'));
    }
  }

  Future<void> sendVerificationCode(String email) async {
    emit(AuthLoadingState());

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/send-verification-code?emailAddress=$email'),
      );

      if (response.statusCode == 200) {
        emit(AuthSendVerificationCodeSuccessState(email));
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to send verification code';
        emit(AuthErrorState(errorMessage));
      }
    } catch (e) {
      debugPrint('Send verification code error: $e');
      emit(AuthErrorState(
          'Failed to send verification code. Please try again.'));
    }
  }

  Future<void> verifyCode(String email, String code) async {
    emit(AuthLoadingState());

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        emit(AuthVerifyCodeSuccessState());
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Verification failed';
        emit(AuthErrorState(errorMessage));
      }
    } catch (e) {
      debugPrint('Verify code error: $e');
      emit(AuthErrorState('Verification failed. Please try again.'));
    }
  }
}
