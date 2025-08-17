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