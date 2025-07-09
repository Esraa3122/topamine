import 'package:flutter/material.dart';
import 'package:test/features/auth/presentation/refactors/sign_up_teacher_body.dart';

class SignUpTeacherScreen extends StatelessWidget {
  const SignUpTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(bottom: false, child: SignUpTeacherBody()),
    );
  }
}
