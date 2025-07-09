import 'dart:io';

import 'package:test/core/enums/rule_register.dart';
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
    File? imageFil,             // إجباري للمعلم
    String? grade, // إجباري للطالب
  }) async {
    // login
    final userCredential = await _dataSource.registerWithEmail(email, password);
    final uid = userCredential.user!.uid;

    // if (role == UserRole.teacher && imageFil == null) {
    //   throw Exception('Teacher image is required.');
    // }
    if (role == UserRole.student &&
        (grade == null || grade.isEmpty)) {
      throw Exception('Academic year is required for students.');
    }

    String? imageUrl;
    // if (role == UserRole.teacher && imageBase64 != null) {
    //   imageUrl = await _dataSource.uploadProfileImage(imageFile, uid);
    // }

    final user = UserModel(
      userId: uid,
      userName: name,
      userEmail: email,
      userRole: role,
      userImage: imageUrl,
      grade: role == UserRole.student ? grade : null,
      phone: phone,
      governorate: governorate,
    );

    await _dataSource.saveUserData(uid, user.toJson());

    await sharedPref.saveUserSession(uid, role.name);
  }

  Future<void> loginUser(String email, String password) async {
    final userCredential = await _dataSource.signInWithEmail(email, password);
    final uid = userCredential.user!.uid;

    final userData = await _dataSource.getUserData(uid);
    final role = userData?['role'] ?? 'student';

    await sharedPref.saveUserSession(uid, role.toString());
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
  return _dataSource.getUserData(uid);
}
}
