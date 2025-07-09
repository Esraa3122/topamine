part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.success({required String successMessage}) = Success;
  const factory AuthState.failure({required String errorMessage}) = Failure;
}
