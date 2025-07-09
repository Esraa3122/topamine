import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  AuthDataSource();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // regester
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
  ) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // login
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // بعدين
  //   Future<String> uploadProfileImage(File file, String uid) async {
  //     final ref = _storage.ref().child('user_images/$uid.jpg');
  //     await ref.putFile(file);
  //     return await ref.getDownloadURL();
  //   }

  //  // بعدين
  //   Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
  //     await _firestore.collection('users').doc(uid).set(userData);
  //   }

  // store data
  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
