import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/enums/status_register.dart';
import 'package:test/core/service/shared_pref/shared_pref_helper.dart';
import 'package:test/features/auth/data/datasources/auth_data_source.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class AuthRepos {
  const AuthRepos(this._dataSource, this.sharedPref);
  final AuthDataSource _dataSource;
  final SharedPrefHelper sharedPref;

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String phone,
    required String governorate,
    File? imageFile,
    String? grade,
    String? subject,
    AccountStatus? status,
  }) async {
    try {
      if (role == UserRole.teacher && imageFile == null) {
        throw Exception('Teacher image is required.');
      }
      if (role == UserRole.teacher && (subject == null || subject.isEmpty)) {
        throw Exception('Subject is required for teachers.');
      }
      if (role == UserRole.student && (grade == null || grade.isEmpty)) {
        throw Exception('Academic year is required for students.');
      }

      final userCredential = await _dataSource.registerWithEmail(
        email,
        password,
      );
      final user = userCredential.user;
      if (user == null) throw Exception('Registration failed');

      await user.updateDisplayName(name);
      await user.updatePhotoURL(imageFile?.path);
      await user.reload();

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _dataSource.uploadProfileImage(imageFile);
      }

      final userModel = UserModel(
        userId: user.uid,
        userName: name,
        userEmail: email,
        userRole: role,
        userImage: imageUrl,
        grade: role == UserRole.student ? grade : null,
        phone: phone,
        governorate: governorate,
        subject: role == UserRole.teacher ? subject : null,
        status: role == UserRole.teacher
            ? AccountStatus.pending
            : AccountStatus.accepted,
      );

      await _dataSource.saveUserData(user.uid, userModel);
      await sharedPref.saveUserSession(user.uid, role.name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('البريد الإلكتروني مستخدم بالفعل');
      } else {
        throw Exception(e.message ?? 'فشل التسجيل');
      }
    }
  }

  // Future<UserModel> loginUser(String email, String password) async {
  //   final userCredential = await _dataSource.signInWithEmail(email, password);
  //   final uid = userCredential.user!.uid;

  //   final user = await _dataSource.getUserData(uid);
  //   if (user == null) {
  //     throw Exception('User data not found.');
  //   }

  //   if (user.blocked == true) {
  //   throw Exception('تم حظر هذا المستخدم من قبل الإدارة.');
  // }

  //   if (user.userRole == UserRole.teacher && user.status != AccountStatus.accepted) {
  //     return user;
  //   }

  //   await sharedPref.saveUserSession(uid, user.userRole.name);
  //   await sharedPref.saveUserStatus(
  //   mapAccountStatusToString(user.status ?? AccountStatus.pending)!,
  // );
  // await sharedPref.saveUserBlocked(user.blocked);
  //   return user;
  // }
  Future<UserModel> loginUser(String email, String password) async {
    try {
      final userCredential = await _dataSource.signInWithEmail(email, password);
      final uid = userCredential.user!.uid;

      final user = await _dataSource.getUserData(uid);
      if (user == null) {
        throw Exception('بيانات المستخدم غير موجودة');
      }

      if (user.blocked == true) {
        throw Exception('تم حظر هذا المستخدم من قبل الإدارة.');
      }

      if (user.userRole == UserRole.teacher &&
          user.status != AccountStatus.accepted) {
        return user;
      }

      await sharedPref.saveUserSession(uid, user.userRole.name);
      await sharedPref.saveUserStatus(
        mapAccountStatusToString(user.status ?? AccountStatus.pending)!,
      );
      await sharedPref.saveUserBlocked(user.blocked);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('كلمة المرور غير صحيحة');
      } else if (e.code == 'user-not-found') {
        throw Exception('المستخدم غير موجود');
      } else {
        throw Exception('حدث خطأ أثناء تسجيل الدخول');
      }
    }
  }

  Future<void> updateUserData(UserModel user) async {
    await _dataSource.updateUserData(user.userId, user.toJson());
  }

  Future<String?> uploadProfileImage(File file) async {
    return _dataSource.uploadProfileImage(file);
  }

  Future<UserModel?> getUserData(String uid) async {
    return _dataSource.getUserData(uid);
  }

  Future<void> setBlocked(String userId, bool block) async {
    await _dataSource.updateUserData(userId, {'blocked': block});
  }

  Future<bool> isUserBlocked(String userId) async {
    final userData = await getUserData(userId);
    return userData?.blocked ?? true;
  }
}
