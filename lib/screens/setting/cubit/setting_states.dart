// States
import 'package:equatable/equatable.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class ChangePasswordLoading extends SettingState {}

class ChangePasswordSuccess extends SettingState {}

class ChangePasswordError extends SettingState {
  final String message;

  const ChangePasswordError(this.message);

  @override
  List<Object> get props => [message];
}
