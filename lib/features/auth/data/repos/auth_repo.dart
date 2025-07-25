import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    File? imageFile, // إجباري للمعلم
    String? grade, // إجباري للطالب
    String? subject, // اجبارى للمعلم
    AccountStatus? status,
  }) async {
    // login
    final userCredential = await _dataSource.registerWithEmail(email, password);
    final uid = userCredential.user!.uid;

    if (role == UserRole.teacher && imageFile == null) {
      throw Exception('Teacher image is required.');
    }
    if (role == UserRole.teacher && (subject == null || subject.isEmpty)) {
      throw Exception('Subject is required for teachers.');
    }
    if (role == UserRole.student && (grade == null || grade.isEmpty)) {
      throw Exception('Academic year is required for students.');
    }


    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _dataSource.uploadProfileImage(imageFile);
    }

    final user = UserModel(
      userId: uid,
      userName: name,
      userEmail: email,
      userRole: role,
      userImage: imageUrl,
      grade: role == UserRole.student ? grade : null,
      phone: phone,
      governorate: governorate,
      subject: role == UserRole.teacher ? subject : null,
      status: role == UserRole.teacher ? AccountStatus.pending : AccountStatus.accepted,
    );

    await _dataSource.saveUserData(uid, user.toJson());

    await sharedPref.saveUserSession(uid, role.name);
  }

  Future<UserModel> loginUser(String email, String password) async {
  final userCredential = await _dataSource.signInWithEmail(email, password);
  final uid = userCredential.user!.uid;

  final userData = await _dataSource.getUserData(uid);

  if (userData == null) {
    throw Exception('User data not found.');
  }

  final user = UserModel.fromJson(userData);

  if (user.userRole == UserRole.teacher && user.status != AccountStatus.accepted) {
    return user;
  }

  await sharedPref.saveUserSession(uid, user.userRole.name);
  return user;
}

//   Future<void> loginUser(String email, String password) async {
//   final userCredential = await _dataSource.signInWithEmail(email, password);
//   final uid = userCredential.user!.uid;

//   final userData = await _dataSource.getUserData(uid);

//   if (userData == null) {
//     throw Exception('User data not found.');
//   }

//   final role = userData['role'] ?? 'student';
//   final status = userData['status'] ?? 'pending';

//   if (role == 'teacher' && status != 'accepted') {
//     throw Exception('حسابك قيد المراجعة، سيتم تفعيله بعد القبول.');
//   }

//   await sharedPref.saveUserSession(uid, role.toString());
// }


  Future<void> updateUserData(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update(user.toJson());
  }

     Future<String?> uploadProfileImage(File file) async {
  return _dataSource.uploadProfileImage(file); // Cloudinary service
}


  Future<Map<String, dynamic>?> getUserData(String uid) async {
    return _dataSource.getUserData(uid);
  }
}
