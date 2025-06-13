import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

part 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  File? get profileImage => _profileImage;

  Future<void> pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _profileImage = File(image.path);
        emit(AuthInitialState());
      }
    } catch (e) {
      emit(AuthErrorState('Failed to pick image: $e'));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());

    final url = Uri.parse('http://healthmate.runasp.net/api/Account/Login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'stayLoggedIn': true,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        emit(AuthLoginSuccessState(token));
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Login failed';
        emit(AuthErrorState(errorMessage));
      }
    } catch (e) {
      emit(AuthErrorState('Error occurred: $e'));
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

    final uri = Uri.parse("http://healthmate.runasp.net/api/Account/Register");
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
        request.files.add(
            await http.MultipartFile.fromPath('Image', _profileImage!.path));
      }

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
      emit(AuthErrorState('Error occurred: $e'));
    }
  }

  Future<void> forgetPassword(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      emit(AuthErrorState('Please enter a valid email address'));
      return;
    }

    emit(AuthLoadingState());

    final url = Uri.parse(
      'https://healthmate.runasp.net/api/Account/send-verification-code?emailAddress=$email',
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
