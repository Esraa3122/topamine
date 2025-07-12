import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/features/splash/view/refactors/body_splash_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('user_id');
      final role = prefs.getString('user_role');

      if (uid != null && role != null) {
        if (role == 'teacher') {
          await context.pushNamedAndRemoveUntil(AppRoutes.navigationTeacher);
        } else {
          await context.pushNamedAndRemoveUntil(AppRoutes.navigationStudent);
        }
      } else {
        await context.pushNamedAndRemoveUntil(AppRoutes.onBoarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodySplashScreen(),
    );
  }
}
