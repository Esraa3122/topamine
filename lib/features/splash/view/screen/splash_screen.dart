import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/enums/status_register.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/shared_pref/shared_pref_helper.dart';
import 'package:test/features/auth/data/datasources/auth_data_source.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';
import 'package:test/features/splash/view/refactors/body_splash_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthRepos authRepo;

  @override
  void initState() {
    super.initState();
    authRepo = AuthRepos(AuthDataSource(), SharedPrefHelper());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

 Future<void> _handleNavigation() async {
  await Future.delayed(const Duration(seconds: 5));

  final firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser == null) {
    _goToOnBording();
    return;
  }

  final userModel = await authRepo.getUserData(firebaseUser.uid);

  if (userModel == null) {
    await FirebaseAuth.instance.signOut();
    await SharedPrefHelper().clearSession();
    _goToLogin();
    return;
  }

  if (userModel.status == AccountStatus.pending) {
   _goToLogin();
    return;
  }

  if (userModel.status == AccountStatus.rejected || userModel.blocked == true) {
    await FirebaseAuth.instance.signOut();
    await SharedPrefHelper().clearSession();
    _goToLogin();
    return;
  }

  if (userModel.status == AccountStatus.accepted) {
    final role = userModel.userRole;
    if (role == UserRole.teacher) {
      await context.pushReplacementNamed(AppRoutes.navigationTeacher);
    } else if (role == UserRole.student) {
      await context.pushReplacementNamed(AppRoutes.navigationStudent);
    } else {
      // Optional fallback
      await FirebaseAuth.instance.signOut();
      await SharedPrefHelper().clearSession();
      _goToLogin();
    }
  }
}



  void _goToOnBording() {
    context.pushReplacementNamed(AppRoutes.onBoarding);
  }

  void _goToLogin() {
    context.pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodySplashScreen(),
    );
  }
}
