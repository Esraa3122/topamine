import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/core/service/cloudinary/cloudinary_service.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class AuthDataSource {
  AuthDataSource();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerWithEmail(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String?> uploadProfileImage(File file) async {
    return await CloudinaryService.uploadImageToCloudinary(file);
  }

  Future<void> saveUserData(String uid, UserModel user) async {
    await _firestore.collection('users').doc(uid).set(user.toJson());
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> updatedFields) async {
    await _firestore.collection('users').doc(uid).update(updatedFields);
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    return UserModel.fromJson(data);
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
















// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:test/core/enums/status_register.dart';
// import 'package:test/core/service/cloudinary/cloudinary_service.dart';

// class AuthDataSource {
//   AuthDataSource();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // register
//   Future<UserCredential> registerWithEmail(
//     String email,
//     String password,
//   ) async {
//     return _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // login
//   Future<UserCredential> signInWithEmail(String email, String password) async {
//     return _auth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   // upload image
//   Future<String?> uploadProfileImage(File file) async {
//     return await CloudinaryService.uploadImageToCloudinary(file);
//   }

//   // store user data
//   Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
//     await _firestore.collection('users').doc(uid).set(userData);
//   }

//   // retrieve user data
//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     final doc = await _firestore.collection('users').doc(uid).get();
//     if (!doc.exists) return null;

//     final data = doc.data();
//     if (data == null) return null;

//     final statusText = data['status'] as String? ?? 'قيد المراجعة';
//     final statusEnum = mapStringToAccountStatus(statusText);

//     data['statusEnum'] = statusEnum;

//     return data;
//   }

//   // auth state changes stream
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
// }




// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:test/core/service/cloudinary/cloudinary_service.dart';

// class AuthDataSource {
//   AuthDataSource();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // final FirebaseStorage _storage = FirebaseStorage.instance;

//   // regester
//   Future<UserCredential> registerWithEmail(
//     String email,
//     String password,
//   ) async {
//     return _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // login
//   Future<UserCredential> signInWithEmail(String email, String password) async {
//     return _auth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   // upload image
//    Future<String?> uploadProfileImage(File file) async {
//     return await CloudinaryService.uploadImageToCloudinary(file);
//   }

//   // store data
//   Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
//     await _firestore.collection('users').doc(uid).set(userData);
//   }

//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     final doc = await _firestore.collection('users').doc(uid).get();
//     return doc.exists ? doc.data() : null;
//   }

//   Stream<User?> get authStateChanges => _auth.authStateChanges();
// }
