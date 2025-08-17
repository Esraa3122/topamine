import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/enums/status_register.dart';
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

    final userCredential = await _dataSource.registerWithEmail(email, password);
    final user = userCredential.user;
    if (user == null) throw Exception('Registration failed');

    await user.updateDisplayName(name);
    await user.reload();

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _dataSource.uploadProfileImage(imageFile);
    }
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
      status: role == UserRole.teacher ? AccountStatus.pending : AccountStatus.accepted,
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


  Future<UserModel> loginUser(String email, String password) async {
    final userCredential = await _dataSource.signInWithEmail(email, password);
    final uid = userCredential.user!.uid;

    final user = await _dataSource.getUserData(uid);
    if (user == null) {
      throw Exception('User data not found.');
    }

    if (user.blocked == false) {
    throw Exception('تم حظر هذا المستخدم من قبل الإدارة.');
  }

    if (user.userRole == UserRole.teacher && user.status != AccountStatus.accepted) {
      return user;
    }

    await sharedPref.saveUserSession(uid, user.userRole.name);
    await sharedPref.saveUserStatus(
    mapAccountStatusToString(user.status ?? AccountStatus.pending)!,
  );
  await sharedPref.saveUserBlocked(user.blocked);
    return user;
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
  return userData?.blocked ?? false;
}


}

















// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test/core/enums/rule_register.dart';
// import 'package:test/core/enums/status_register.dart';
// import 'package:test/core/service/shared_pref/shared_pref_helper.dart';
// import 'package:test/features/auth/data/datasources/auth_data_source.dart';
// import 'package:test/features/auth/data/models/user_model.dart';

// class AuthRepos {
//   const AuthRepos(this._dataSource, this.sharedPref);
//   final AuthDataSource _dataSource;
//   final SharedPrefHelper sharedPref;

//   Future<void> registerUser({
//     required String name,
//     required String email,
//     required String password,
//     required UserRole role,
//     required String phone,
//     required String governorate,
//     File? imageFile, // إجباري للمعلم
//     String? grade, // إجباري للطالب
//     String? subject, // اجبارى للمعلم
//     AccountStatus? status,
//   }) async {
//     // login
//     final userCredential = await _dataSource.registerWithEmail(email, password);
//     final uid = userCredential.user!.uid;

//     if (role == UserRole.teacher && imageFile == null) {
//       throw Exception('Teacher image is required.');
//     }
//     if (role == UserRole.teacher && (subject == null || subject.isEmpty)) {
//       throw Exception('Subject is required for teachers.');
//     }
//     if (role == UserRole.student && (grade == null || grade.isEmpty)) {
//       throw Exception('Academic year is required for students.');
//     }


//     String? imageUrl;
//     if (imageFile != null) {
//       imageUrl = await _dataSource.uploadProfileImage(imageFile);
//     }

//     final user = UserModel(
//       userId: uid,
//       userName: name,
//       userEmail: email,
//       userRole: role,
//       userImage: imageUrl,
//       grade: role == UserRole.student ? grade : null,
//       phone: phone,
//       governorate: governorate,
//       subject: role == UserRole.teacher ? subject : null,
//       status: role == UserRole.teacher ? AccountStatus.pending : AccountStatus.accepted,
//     );

//     await _dataSource.saveUserData(uid, user.toJson());

//     await sharedPref.saveUserSession(uid, role.name);
//   }

//   Future<UserModel> loginUser(String email, String password) async {
//   final userCredential = await _dataSource.signInWithEmail(email, password);
//   final uid = userCredential.user!.uid;

//   final userData = await _dataSource.getUserData(uid);

//   if (userData == null) {
//     throw Exception('User data not found.');
//   }

//   final user = UserModel.fromJson(userData);

//   if (user.userRole == UserRole.teacher && user.status != AccountStatus.accepted) {
//     return user;
//   }

//   await sharedPref.saveUserSession(uid, user.userRole.name);
//   return user;
// }

// //   Future<void> loginUser(String email, String password) async {
// //   final userCredential = await _dataSource.signInWithEmail(email, password);
// //   final uid = userCredential.user!.uid;

// //   final userData = await _dataSource.getUserData(uid);

// //   if (userData == null) {
// //     throw Exception('User data not found.');
// //   }

// //   final role = userData['role'] ?? 'student';
// //   final status = userData['status'] ?? 'pending';

// //   if (role == 'teacher' && status != 'accepted') {
// //     throw Exception('حسابك قيد المراجعة، سيتم تفعيله بعد القبول.');
// //   }

// //   await sharedPref.saveUserSession(uid, role.toString());
// // }


//   Future<void> updateUserData(UserModel user) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.userId)
//         .update(user.toJson());
//   }

//      Future<String?> uploadProfileImage(File file) async {
//   return _dataSource.uploadProfileImage(file); // Cloudinary service
// }


//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     return _dataSource.getUserData(uid);
//   }
// }
