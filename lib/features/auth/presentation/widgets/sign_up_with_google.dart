import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test/core/common/toast/buildawesomedialog.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/shared_pref/shared_pref_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class SigninWithGoogle extends StatelessWidget {
  const SigninWithGoogle({this.height, this.width, super.key});
  final double? height;
  final double? width;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      print('###########################################################');
      print('ID Token: $idToken');
      print('###########################################################');

      var user = userCredential.user;

      if (user == null) {
        throw Exception('فشل تسجيل الدخول: المستخدم غير موجود');
      }

      if (user.displayName == null || user.displayName!.isEmpty) {
        await user.updateDisplayName(googleUser.displayName ?? 'New User');
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }

      final uid = user!.uid;

      final userData = {
        'id': uid,
        'name': user.displayName ?? googleUser.displayName ?? 'User',
        'email': user.email ?? '',
        'avatar': user.photoURL ?? '',
        'role': 'teacher',
        'phone': user.phoneNumber ?? '',
        'governorate': '',
      };

      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('users').doc(uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        try {
          await docRef.set(userData);
        } catch (e) {
          throw Exception('حدث خطأ أثناء حفظ البيانات');
        }
      } else {
        debugPrint('المستخدم موجود مسبقًا في Firestore');
      }
      await sl<SharedPrefHelper>().saveUserSession(user.uid, 'teacher');

      await context.pushReplacementNamed(AppRoutes.navigationTeacher);
    } catch (e) {
      debugPrint(' Google Sign-In failed: $e');
      buildAwesomeDialogError(
        'Error',
        'فشل تسجيل الدخول بواسطة Google:\n$e',
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        signInWithGoogle(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: context.color.textFormBorder!),
      ),
      icon: Image.network(
        'https://tse3.mm.bing.net/th/id/OIP.JflGW8e1fT4_ttSuFTQXJwHaHj?rs=1&pid=ImgDetMain&o=7&rm=3',
        width: 24,
        height: 24,
      ),
      label: TextApp(
        text: context.translate(LangKeys.loginWithGoogal),
        theme: context.textStyle.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeightHelper.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
