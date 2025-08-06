import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/enums/status_register.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(AuthInitial());
  final AuthRepos repository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String phone,
    required String governorate,
    AccountStatus? status,
    File? imageFile,
    String? grade,
    String? subject,
  }) async {
    emit(AuthLoading());

    try {
      await repository.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
        imageFile: imageFile,
        grade: grade,
        phone: phone,
        governorate: governorate,
        subject: subject,
        status: status,
      );

      emit(
        AuthSuccess(
          successMessage: LangKeys.accountCreatedSuccessfully,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure(errorMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(
          AuthFailure(
            errorMessage: LangKeys.theAccountAlreadyExistsForThatEmail,
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      await repository.loginUser(email, password);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(AuthFailure(errorMessage: 'Unable to get user ID'));
        return;
      }

      final userData = await repository.getUserData(uid);
      if (userData == null) {
        emit(AuthFailure(errorMessage: 'User data not found'));
        return;
      }

      if (userData.blocked == true) {
        await FirebaseAuth.instance.signOut();
        emit(AuthFailure(errorMessage: 'تم حظر حسابك، لا يمكنك تسجيل الدخول.'));
        return;
      }

      if (userData.userRole == UserRole.teacher) {
        if (userData.status == AccountStatus.pending) {
          emit(AuthWaitingApproval());
          return;
        } else if (userData.status == AccountStatus.rejected) {
          emit(
            AuthFailure(errorMessage: 'تم رفض طلبك، لا يمكنك تسجيل الدخول.'),
          );
          return;
        }
      }

      emit(
        AuthSuccess(
          successMessage: LangKeys.loggedSuccessfully,
          user: userData,
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(AuthFailure(errorMessage: 'user not found'));
      } else if (ex.code == 'wrong-password') {
        emit(AuthFailure(errorMessage: 'wrong password'));
      } else {
        emit(AuthFailure(errorMessage: LangKeys.loggedError));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      
      await GoogleSignIn().signOut();
      await GoogleSignIn().disconnect();

      await FirebaseAuth.instance.signOut();

      await repository.sharedPref.clearSession();

      emit(AuthSuccess(successMessage: 'تم تسجيل الخروج بنجاح.'));
    } catch (e) {
      emit(AuthFailure(errorMessage: 'فشل تسجيل الخروج: ${e.toString()}'));
    }
  }
}
