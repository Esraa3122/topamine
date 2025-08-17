import 'package:test/features/auth/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String successMessage;
  final UserModel? user;
  AuthSuccess({required this.successMessage, this.user});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure({required this.errorMessage});
}

class AuthWaitingApproval extends AuthState {}
