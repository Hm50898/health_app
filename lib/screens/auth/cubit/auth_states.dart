part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  final String token;

  AuthLoginSuccessState(this.token);
}

class AuthRegisterSuccessState extends AuthState {
  final String userId;

  AuthRegisterSuccessState(this.userId);
}

class AuthForgetPasswordSuccessState extends AuthState {
  final String email;

  AuthForgetPasswordSuccessState(this.email);
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}
