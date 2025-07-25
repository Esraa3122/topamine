import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState.initial());
  final AuthRepos repository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String phone,
    required String governorate,
    // File? imageFil,
    String? grade,
  }) async {
    emit(const Loading());

    try {
      await repository.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
        // imageFil: imageFil,
        grade: grade,
        phone: phone,
        governorate: governorate,
      );

      emit(const Success(successMessage: LangKeys.accountCreatedSuccessfully));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const Failure(errorMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(
          const Failure(
            errorMessage: LangKeys.theAccountAlreadyExistsForThatEmail,
          ),
        );
      }
    } catch (e) {
      emit(Failure(errorMessage: e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(const Loading());

    try {
      await repository.loginUser(email, password);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(const Failure(errorMessage: 'Unable to get user ID'));
        return;
      }

      final userData = await repository.getUserData(uid);
      if (userData == null) {
        emit(const Failure(errorMessage: 'User data not found'));
        return;
      }

      final user = UserModel.fromJson(userData);
      await repository.sharedPref.saveUserSession(
        user.userId,
        user.userRole.name,
      );
      emit(
        const Success(
          successMessage: LangKeys.loggedSuccessfully,
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(const Failure(errorMessage: 'user not found'));
      } else if (ex.code == 'wrong-password') {
        emit(const Failure(errorMessage: 'wrong password'));
      } else {
        emit(const Failure(errorMessage: LangKeys.loggedError));
      }
    } catch (e) {
      emit(Failure(errorMessage: e.toString()));
    }
  }
}
