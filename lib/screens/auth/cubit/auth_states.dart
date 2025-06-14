part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  final String token;
  AuthLoginSuccessState(this.token);
}

class AuthLogoutSuccessState extends AuthState {}

class AuthRegisterSuccessState extends AuthState {
  final String userId;
  AuthRegisterSuccessState(this.userId);
}

class AuthPatientRegisterSuccessState extends AuthState {}

class AuthSendVerificationCodeSuccessState extends AuthState {
  final String email;
  AuthSendVerificationCodeSuccessState(this.email);
}

class AuthVerifyCodeSuccessState extends AuthState {}

class AuthForgetPasswordSuccessState extends AuthState {
  final String email;
  AuthForgetPasswordSuccessState(this.email);
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
