import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

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
        emit(AuthSuccessState(token));
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Login failed';
        emit(AuthErrorState(errorMessage));
      }
    } catch (e) {
      emit(AuthErrorState('Error occurred: $e'));
    }
  }
}
