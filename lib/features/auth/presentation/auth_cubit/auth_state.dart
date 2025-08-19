import 'package:test/features/auth/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess({required this.successMessage, this.user});
  final String successMessage;
  final UserModel? user;
}

class AuthFailure extends AuthState {
  AuthFailure({required this.errorMessage});
  final String errorMessage;
}

class AuthWaitingApproval extends AuthState {}
