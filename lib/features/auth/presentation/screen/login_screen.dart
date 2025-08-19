import 'package:flutter/material.dart';
import 'package:test/features/auth/presentation/refactors/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SafeArea(bottom: false, child: LoginBody()),
    );
  }
}
