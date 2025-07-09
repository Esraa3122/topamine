import 'package:flutter/material.dart';
import 'package:test/features/auth/presentation/refactors/sign_up_student_body.dart';

class SignUpStudentScreen extends StatelessWidget {
  const SignUpStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(bottom: false, child: SignUpStudentBody()),
    );
  }
}
