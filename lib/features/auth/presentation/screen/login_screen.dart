import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/auth/presentation/refactors/auth_custom_painter.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:test/core/extensions/context_extension.dart';
// import 'package:test/features/auth/presentation/refactors/auth_custom_painter.dart';
import 'package:test/features/auth/presentation/refactors/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 100.h),
        painter: AuthCustomPainter(
            gradient: LinearGradient(colors: [
          context.color.bluePinkLight!,
          context.color.bluePinkLight!,
          context.color.bluePinkLight!,
          context.color.bluePinkDark!
        ])),
      ),
      body: const SafeArea(bottom: false, child: LoginBody()),
    );
  }
}
